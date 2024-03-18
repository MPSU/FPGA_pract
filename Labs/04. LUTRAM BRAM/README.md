# Лабораторная работа 4. LUTRAM и BRAM

Память представляет из себя достаточно важный и часто используемый элемент в цифровых схемах. Буферы, кэши, запоминающие массивы и многие другие блоки основываются именно на памяти. Важно уточнить, что говоря слово "память", в данной лабораторной работе мы понимаем только статическую память, расположенную на одном полупроводниковом кристалле со всей остальной логикой. То есть из рассмотрения выпадают внешние микросхемы памяти, такие как SDRAM, DDR и тому подобное.

В FPGA Xilinx 7 существует несколько способов реализовать запоминающие ячейки и массивы памяти:
 * На регистрах - самый простой и очевидный способ, можно использовать регистры из Slicе для хранения данных.
 * LUT как память (Distributed RAM, LUTRAM) - часть таблиц LUT в FPGA можно использовать для хранения данных.
 * Блочная память (BRAM) - специальные аппаратные блоки памяти

Давайте рассмотрим максимальный объём памяти, который можно использовать в FPGA при разных способах реализации, на примере FPGA Xilinx Artix 7 100T (точка в цифрах для лучшей читаемости цифр, она не отделяет дробные части чисел):
 * Регистры: 126.800 бит или 15.850 байт
 * LUTRAM: 1.216.512 бит или 152.064 байт
 * BRAM: 4.976.640 бит или 622.080 байт

С помощью регистров можно реализовать достаточно скромный суммарный объём памяти. LUTRAM позволяет реализовать более существенный объём, а максимальный объём достигается использованием BRAM. Также у BRAM есть одно важное достоинство - в отличие от регистров и LUTRAM, **BRAM не потребляет ценные ресурсы логики FPGA**, так как является отдельными аппаратными блоками на кристалле, а не перенастроенной под память "гибкой" логикой.

## LUTRAM в FPGA Xilinx 7

Казалось бы, если BRAM не потребляет гибкую логику и такой памяти в распоряжении инженера на FPGA в разы больше, чем любой другой, то зачем использовать LUTRAM? Ответ достаточно прост. LUTRAM и регистры позволяют реализовать асинхронное чтение из памяти, а BRAM реализует только синхронное чтение.

> Если вы студент МИЭТ, то вы можете вернуться к [лабораторной работе 3 курса АПС](https://github.com/MPSU/APS/tree/master/Labs/03.%20Register%20file%20and%20memory) и, проанализировав результаты синтеза, убедиться, что память инструкций, имеющая асинхронное чтение, на самом деле использовала LUTRAM, а память данных, имеющая синхронное чтение, реализовалась на базе BRAM.


### Пример использования LUTRAM

Для принудительного использования LUTRAM в Vivado есть конструкция   `(* ram_style="distributed" *)`, но, в большинстве случаев, Vivado будет использовать LUTRAM всегда, когда из памяти выполняется асинхронное чтение.

Давайте рассмотрим описание памяти, использующее LUTRAM:

```verilog
module lutram
#(
  parameter RAM_WIDTH     = 8,
  parameter RAM_ADDR_BITS = 5
)
(
  input  logic                     clk_i,
  input  logic [RAM_WIDTH-1:0]     wdata_i,
  input  logic [RAM_ADDR_BITS-1:0] waddr_i,
  input  logic                     we_i,

  input  logic [RAM_ADDR_BITS-1:0] raddr_i,
  output logic [RAM_WIDTH-1:0]     rdata_o
);

  (* ram_style="distributed" *)
  logic [RAM_WIDTH-1:0] lutram [(2**RAM_ADDR_BITS)-1:0];

  always_ff @(posedge clk_i) begin
    if (we_i)
      lutram[waddr_i] <= wdata_i;
  end

  assign rdata_o = lutram[raddr_i];

endmodule
```

Вспомним, что означает каждый порт памяти:
 * clk_i - сигнал тактовой частоты
 * wdata_i - данные для записи
 * waddr_i - адрес для записи
 * we_i - разрешение на запись
 * raddr_i - адрес чтения
 * rdata_o - результат чтения из памяти

Параметр памяти `RAM_WIDTH` определяет ширину шин данных в битах, а параметр `RAM_ADDR_BITS` определяет ширину шин адреса и глубину памяти. Например, `RAM_ADDR_BITS = 10` приведёт к появлению памяти глубиной в 1024 ячейки.

Мы видим конструкцию `(* ram_style="distributed" *)`, а также строчку `assign rdata_o = lutram[raddr_i];`, которая реализует асинхронное чтение из памяти.

Запись в память реализована в `always_ff`-блоке и является синхронной
```verilog
  always_ff @(posedge clk_i) begin
    if (we_i)
      lutram[waddr_i] <= wdata_i;
  end
```


## BRAM в FPGA Xilinx 7

Напомним, что отличительной особенностью BRAM является синхронное чтение из памяти. Давайте рассмотрим целый ряд примеров таких памятей в разных конфигурациях (на самом деле это всё разные режимы работы одного аппаратного блока BRAM в FPGA).

### BRAM - single port

Самая простая память - это память с одним портом. Через один порт в один момент времени мы можем либо писать, либо читать данные. Одновременно можно производить только одну операцию.

Давайте посмотрим на пример такой памяти (это память No change mode).


```verilog
module bram_1p_no_change
#(
  parameter RAM_WIDTH     = 8,
  parameter RAM_ADDR_BITS = 10
)
(
  input  logic                     clk_i,
  input  logic [RAM_ADDR_BITS-1:0] addr_i,
  input  logic [RAM_WIDTH-1:0]     data_i,
  input  logic                     we_i,
  input  logic                     en_i,
  output logic [RAM_WIDTH-1:0]     data_o
);

  localparam RAM_DEPTH = 2**RAM_ADDR_BITS;

  logic [RAM_WIDTH-1:0] bram [RAM_DEPTH-1:0];
  logic [RAM_WIDTH-1:0] data_out_ff;

  always_ff @(posedge clk_i) begin
    if (en_i) begin
      if (we_i)
        bram[addr_i] <= data_i;
      else
        data_out_ff  <= bram[addr_i];
    end
  end

  assign data_o = data_out_ff;

endmodule
```

В этом примере можно увидеть, что чтение синхронное, то есть данные не выводятся наружу сразу через `assign` (как в примере LUTRAM), а сначала попадают в регистр `data_out_ff`, выход которого уже выводится на порт модуля `data_o`.

Также появляется новый порт: `en_i` - это разрешение на работу памяти, используемое для повышения энергоэффективности путем отключения памяти в те такты, когда она не нужна.

Важным аспектом порта памяти является поведение шины `rdata` (результат чтения) при выполнении операции записи. Разделяют несколько возможных сценариев поведения:

 * No change
 * Read first
 * Write first

 Рассмотрим их подробнее.

#### No change

Режим "No change" предполагает, что значение на выходе `rdata_o` после записи не будет меняться, по сути, там останется результат предыдущей операции чтения.

Мы можем прочитать такую логику в Verilog описании: "если есть `we_i`, то производим запись, если `we_i` нету, то только тогда обновляем `data_out_ff`".

```verilog
  always_ff @(posedge clk_i) begin
    if (en_i) begin
      if (we_i)
        bram[addr_i] <= data_i;
      else
        data_out_ff    <= bram[addr_i];
    end
  end
```

Такой тип памяти встречается очень часто и считается наиболее энергоэффективными, причем как в FPGA, так и в ASIC, поскольку при записи не происходит переключения регистра чтения.

#### Read First Mode

Существуют дизайны, где отступление от политики "No change" позволяет упростить логику или повысить её эффективность. Одной из альтернативных политик является "Read First". Давайте сразу посмотрим на её описание.

```verilog
  always_ff @(posedge clk_i) begin
    if (en_i) begin
      if (we_i)
        bram[addr_i] <= data_i;

      data_out_ff <= bram[addr_i];
    end
  end
```

Можно увидеть, что строчка `data_out_ff <= bram[addr_i];` не находится под условием `if (we_i)`, и не зависит от него. То есть память производит чтение всегда, когда активен сигнал `en_i`. Так как используется неблокирующее присваивание `<=`, то при записи в регистр `data_out_ff` попадёт значение, которое **хранилось в памяти до записи** (не то значение, которое записывается в данный момент).

#### Write First Mode

Политика "Write First" реализует обратный "Read First" алгоритм.

```verilog
  always_ff @(posedge clk_i) begin
    if (en_i) begin
      if (we_i) begin
        bram[addr_i] <= data_i;
        data_out_ff  <= data_i;
      end else
        data_out_ff <= bram[addr_i];
    end
  end
```

В описании явным образом определено, что `data_out_ff  <= data_i;` при записи и `data_out_ff <= bram[addr_i];` при чтении. То есть **в регистр `data_out_ff` попадает новое записываемое слово при записи** и вычитанное из памяти значение при чтении. 

#### Дополнительный выходной регистр
Для увеличения тактовой частоты работы BRAM можно добавить ещё один дополнительный регистр на выход чтения:

```verilog
  always_ff @(posedge clk_i) begin
    if (en_i) begin
      if (we_i)
        bram[addr_i] <= data_i;
      else
        data_out_ff  <= bram[addr_i];
    end
  end

  always_ff @(posedge clk_i) begin
    if (rst_i)
      data_out_reg_ff <= {RAM_WIDTH{1'b0}};
    else if (reg_en_i)
      data_out_reg_ff <= data_out_ff;
  end

  assign data_o = data_out_reg_ff;
```

В таком примере регистр `data_out_reg_ff` защелкивает значение из уже знакомого нам `data_out_ff`. Таким образом, повышается тактовая частота, но увеличивается латентность памяти (память теперь выдаёт **результат чтения не на следующий такт, а через такт**).

#### Память с byte-enable

Часто при записи в память требуется перезаписывать не всё слово целиком, а только отдельные байты. Самым распространенным примером является обращение процессора в память данных при операциях над 8 и 16-битными данными.

Давайте рассмотрим такой модуль памяти:

```verilog
module bram_1p_byte_en
#(
  parameter NB_COL = 4,
  parameter COL_WIDTH = 8,
  parameter RAM_ADDR_BITS = 10,
)
(
  input  logic                           clk_i,
  input  logic [RAM_ADDR_BITS-1:0]       addr_i,
  input  logic [(NB_COL*COL_WIDTH)-1:0]  data_i,
  input  logic [NB_COL-1:0]              we_i,
  input  logic                           en_i,

  output logic [(NB_COL*COL_WIDTH)-1:0]  data_o
);

  localparam RAM_DEPTH = 2**RAM_ADDR_BITS;

  logic [(NB_COL*COL_WIDTH)-1:0] bram [RAM_DEPTH-1:0];
  logic [(NB_COL*COL_WIDTH)-1:0] read_data_ff;

  always_ff @(posedge clk_i) begin
    if (en_i)
      read_data_ff <= bram[addr_i];
  end

  generate
  genvar i;
     for (i = 0; i < NB_COL; i = i+1) begin: byte_write
       always_ff @(posedge clk_i)
         if (en_i)
           if (we_i[i])
             bram[addr_i][(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= data_i[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
      end
  endgenerate

  assign data_o = read_data_ff;

endmodule
```

Мы видим, что сигнал `we_i` стал многобитным, появились параметры `COL_WIDTH` - количество байтов, `COL_WIDTH` - ширина байта (на случай, если понадобится отличная от 8).

Чтение из памяти реализовано через отдельный `always_ff` блок:

```verilog
  always_ff @(posedge clk_i) begin
    if (en_i)
      read_data_ff <= bram[addr_i];
  end
```

Самый интересный фрагмент тут это `always_ff` блок записи в память:

```verilog
  generate
  genvar i;
     for (i = 0; i < NB_COL; i = i+1) begin: byte_write
       always_ff @(posedge clk_i)
         if (en_i)
           if (we_i[i])
             bram[addr_i][(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= data_i[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
      end
  endgenerate
```

Здесь используется конструкция `generate`, которая перебирает все байты, и для каждого i-го байта проверяет бит `we_i[i]`. Если этот бит равен 1, то в соответствующий байт происходит запись.

### BRAM - simple dual port

Если теперь вернуться к примеру памяти на базе LUTRAM, то мы можем с уверенностью сказать, что рассмотренная в том примере память является simple dual port, так как имеет раздельные адреса для чтения и записи, а сами эти операции могут производиться одновременно.

### BRAM - true dual port

### BRAM - 2 clock



## Задание лабораторной работы

1. Чем отличается LUTRAM от BRAM?
2. Что такое синхронное и асинхронное чтение из памяти?