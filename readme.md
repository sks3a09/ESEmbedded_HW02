HW02
===
This is the hw02 sample. Please follow the steps below.

# Build the Sample Program

1. Fork this repo to your own github account.

2. Clone the repo that you just forked.

3. Under the hw02 dir, use:

	* `make` to build.

	* `make clean` to clean the ouput files.

4. Extract `gnu-mcu-eclipse-qemu.zip` into hw02 dir. Under the path of hw02, start emulation with `make qemu`.

	See [Lecture 02 ─ Emulation with QEMU] for more details.

5. The sample is designed to help you to distinguish the main difference between the `b` and the `bl` instructions.  

	See [ESEmbedded_HW02_Example] for knowing how to do the observation and how to use markdown for taking notes.

# Build Your Own Program

1. Edit main.s.

2. Make and run like the steps above.

# HW02 Requirements

1. Please modify main.s to observe the `push` and the `pop` instructions:  

	Does the order of the registers in the `push` and the `pop` instructions affect the excution results?  

	For example, will `push {r0, r1, r2}` and `push {r2, r0, r1}` act in the same way?  

	Which register will be pushed into the stack first?

2. You have to state how you designed the observation (code), and how you performed it.  

	Just like how [ESEmbedded_HW02_Example] did.

3. If there are any official data that define the rules, you can also use them as references.

4. Push your repo to your github. (Use .gitignore to exclude the output files like object files or executable files and the qemu bin folder)

[Lecture 02 ─ Emulation with QEMU]: http://www.nc.es.ncku.edu.tw/course/embedded/02/#Emulation-with-QEMU
[ESEmbedded_HW02_Example]: https://github.com/vwxyzjimmy/ESEmbedded_HW02_Example

--------------------

- [ ] **If you volunteer to give the presentation next week, check this.**

--------------------
HW02
===
## 1. 實驗題目
撰寫簡易組語觀察 registers 的順序會不會影響 push 和 pop 指令。
## 2. 實驗步驟
1. 先將資料夾 gnu-mcu-eclipse-qemu 完整複製到 ESEmbedded_HW02 資料夾中
2. 根據 [ARM infomation center](http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0489e/Cihfddaf.html) 敘述的 push, pop 用法
	* PUSH{cond} reglist
	* POP{cond} reglist
	
	cond
		is an optional condition code.

	reglist
		is a non-empty list of registers, enclosed in braces. It can contain register ranges. It must be comma separated if it contains more than one register or register range.
3. 設計測試程式 main.s ，從 _start 開始後依序執行，並且觀察第13行`push {r0,r1,r2}`和 第19行`push {r2,r0,r1}`之間的差異，以及第14行`pop {r0,r1,r2}`和第20行`pop {r1,r2,r0}`之間的差異。

main.s
```assembly
_start:
    nop
    mov r0,1
    mov r1,2
    mov r2,3
    push {r0,r1,r2}
    pop {r0,r1,r2}
    nop
    mov r0,4
    mov r1,5
    mov r2,6
    push {r2,r0,r1}
    pop {r1,r2,r0}
    nop
    mov r0,7
    mov r1,8
    mov r2,9
    push {r0}
    push {r1}
    push {r2}
    pop {r1}
    pop {r2}
    pop {r0}
    nop
```
4. 在Makefile中加入`$(CROSS-COMPILER)objdump -D main.elf` ，將 main.s 編譯並以 qemu 模擬， `$ make clean`, `$ make`, `$ make qemu`
開啟另一 Terminal 連線 `$ arm-none-eabi-gdb` ，再輸入 `target remote localhost:1234` 連接，輸入兩次的 `ctrl + x` 再輸入 `2`, 開啟 Register 以及指令，並且輸入 `si` 單步執行觀察。

![](https://i.imgur.com/4CDys24.png)

objdump的結果

查看反組譯的結果會發現原本在第19行的 `push {r2,r0,r1}` 變成了 `push {r0,r1,r2}`，第20行的`pop {r1,r2,r0}` 變成了 `pop {r0,r1,r2}`

5. 輸入 `si` 單步執行觀察，執行完第12行mov指令，暫存器r0,r1,r2的值辦更改，r0的值為1，r1的值為2，r2的值為3。

![](https://i.imgur.com/8HDERo2.png)
![](https://i.imgur.com/dEtk8h2.png)

6. 執行完第13行push指令，sp的值由0x20000100被更改為0x200000f4，因為push的三個值進入stack。

![](https://i.imgur.com/EoGUTcN.png)
![](https://i.imgur.com/zEl4Ghk.png)
![](https://i.imgur.com/bYELlLx.png)

利用gdb查看stack位址中存放的值，發現`push {r0,r1,r2}`會由r2先push再push r1，最後才是r0，所以可以知道是由右到左進行push

7.
