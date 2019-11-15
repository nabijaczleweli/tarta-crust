extern crate libc;

use libc::{access, sysconf, _SC_PHYS_PAGES, R_OK};
use std::os::raw::c_longlong;
use std::{process, env, str};
use std::ffi::CStr;
use std::io::Write;
use std::fs::File;


static KSM_MAX_KERNEL_PAGES_FILE_B: &[u8] = b"/sys/kernel/mm/ksm/max_kernel_pages\0";
static KSM_RUN_FILE: &str = "/sys/kernel/mm/ksm/run";

fn ksm_max_kernel_pages_file() -> &'static str {
    unsafe { str::from_utf8_unchecked(&KSM_MAX_KERNEL_PAGES_FILE_B[..KSM_MAX_KERNEL_PAGES_FILE_B.len() - 1]) }
}

fn ksm_max_kernel_pages_file_c() -> &'static CStr {
    unsafe { CStr::from_bytes_with_nul_unchecked(KSM_MAX_KERNEL_PAGES_FILE_B) }
}


fn write_value(value: u64, filename: &str) -> i32 {
    File::create(filename).and_then(|mut f| writeln!(f, "{}", value).map(|_| f)).and_then(|f| f.sync_all()).is_err() as i32
}

fn ksm_max_kernel_pages() -> u64 {
    env::var("KSM_MAX_KERNEL_PAGES").ok().and_then(|var| var.parse::<c_longlong>().map(|value| value as u64).ok()).unwrap_or_else(|| {
        // Unless KSM_MAX_KERNEL_PAGES is set, let KSM munch up to half of total memory.
        (unsafe { sysconf(_SC_PHYS_PAGES) }) as u64 / 2
    })
}

fn start() -> i32 {
    if unsafe { access(ksm_max_kernel_pages_file_c().as_ptr(), R_OK) } >= 0 {
        write_value(ksm_max_kernel_pages(), ksm_max_kernel_pages_file());
    }

    write_value(1, KSM_RUN_FILE)
}

fn stop() -> i32 {
    write_value(0, KSM_RUN_FILE)
}


fn main() {
    let mut args = env::args();
    let program_name = args.next().unwrap();

    let res = match args.next().as_ref().map(String::as_ref) {
        Some("start") => start(),
        Some("stop") => stop(),
        _ => {
            eprintln!("Usage: {} {{start|stop}}", program_name);
            1
        }
    };
    process::exit(res);
}