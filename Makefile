boot32:
	nasm -f bin  boot32.asm -o boot.bin
	qemu-system-x86_64 -fda boot.bin

boot:
	nasm -f bin boot.asm -o boot.bin
	qemu-system-x86_64 -fda boot.bin

git:
	@read -p "Enter commit message: " msg; \
	git add .; \
	git commit -m "$$msg"; \
	git branch -M main; \
	git push -u origin main
