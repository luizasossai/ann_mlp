Projeto de Descrição de um Neurônio Artificial em VHDL
Trabalho feito para a disciplina SEL0632 - Linguagem de Descrição de Hardware. Consistem em arquivos VHDL para a formação de um pacote para ponto fixo, um pacote com função de ativação para um neurônio artificial e um programa para neurônio artificial. É apresentado também test bench para os pacotes. É utilizada a versão VHDL de 1993.

Autores
Luiza Sossai de Sousa - 10748441
Gustavo Simões Belote - 10748584

Arquivos
A pasta anm_mlp contém a pasta vhdl que contém os arquivos .vhd esses são:
fixed_package: pacote que define o tipo fixed e funções que o utilizam.
neuron_pkg: pacote que contém 2 funções de ativação para um neurônio artificial.
neuron: entidade e arquitetura do corpo de 1 neurônio.
fixed_package_tb: test bench para o fixed_package.
activion_function_tb: test bench para a função de ativação.
Além disso esta pasta contém o arquivo activation_function_tb.tcl
A pasta anm_mlp contém a pasta data que contém o arquivo de dados data_activ.dat, que contém dados para o test bench das funções de ativação.
A pasta anm_mlp contém a pasta doc que contém o relatório final do projeto

Software necessários
ModelSim-Intel FPGA Edition software.

Realizando os testes
Teste do fixed_package
Abrir no Modelsim um projeto contendo fixed_package.vhd e fixed_package_tb.vhd.
Colocar a ordem de prioridade de compilação fixed_package.vhd seguido do fixed_package_tb.vhd.
Compilar.
Iniciar a simulação, não será gerado ondas, somente avisos sobre os testes, se ocorrer algum erro o mesmo será indicado

Teste das funções de ativação
Criar uma pasta contendo  o fixed_package.vhdl,  activation_function.vhd, data_actv.dat e o activation_function_tb.tcl.
Criar um projeto no ModelSim e adicionar os arquivos  fixed_package.vhd  e activation_function.vhd. 
Colocar a ordem de prioridade de compilação fixed_package.vhd seguido do activation_function.vhd.
Compilar.
Em Tools → Tlc  → Execute Macro e por fim selecionar o arquivo activation_function_tb.tcl.
Selecione X_real, clique no menu Format->Format->Analog (custom)... e altere Height para 150, Max para 8 e Min para -8.
Selecione Y1_real, clique no menu Format->Format->Analog (custom)... e altere Height para 150, Max para 1 e Min para -1.
Selecione Y2_real, clique no menu Format->Format->Analog (custom)... e altere Height para 150, Max para 1 e Min para -1.

Referências
TSMOTS, Ivan; SKOROKHODA, Oleksa; RABYK, Vasyl. Hardware implementation of sigmoid activation functions using FPGA. In: 2019 IEEE 15th International Conference on the Experience of Designing and Application of CAD Systems (CADSM). IEEE, 2019. p. 34-38.
