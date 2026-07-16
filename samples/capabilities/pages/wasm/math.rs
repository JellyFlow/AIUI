#![no_std]

#[no_mangle]
pub extern "C" fn add(left: i32, right: i32) -> i32 {
    left + right
}

#[no_mangle]
pub extern "C" fn mul(left: i32, right: i32) -> i32 {
    left * right
}

#[no_mangle]
pub extern "C" fn score(seed: i32) -> i32 {
    add(mul(seed, 7), 11)
}

#[panic_handler]
fn panic(_: &core::panic::PanicInfo) -> ! {
    loop {}
}
