extern "C" void kmain() {
  const short color = 0x0f00;
  const char *msg = "With great power comes great responsibility.";
  short *vga = (short *) 0xb8000;
  for (int i = 0; i < 16; i++) {
    vga[i+80] = color | msg[i];
  }
}
