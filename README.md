# ann_mlp
Artificial Neural Network - Multilayer Perceptron
Software necessários
* ModelSim-Intel FPGA Edition software.


Realizando os testes
1. Teste do fixed_package
1.1 Abrir no Modelsim um projeto contendo fixed_package.vhd e fixed_package_tb.vhd.
1.2 Colocar a ordem de prioridade de compilação fixed_package.vhd seguido do fixed_package_tb.vhd.
1.3Compilar.
1.4 Iniciar a simulação, não será gerado ondas, somente avisos sobre os testes, se ocorrer algum erro o mesmo será indicado


2. Teste das funções de ativação
2.1Criar uma pasta contendo  o fixed_package.vhdl,  activation_function.vhd, data_actv.dat e o activation_function_tb.tcl.
2.2 Criar um projeto no ModelSim e adicionar os arquivos  fixed_package.vhd  e activation_function.vhd. 
2.3 Colocar a ordem de prioridade de compilação fixed_package.vhd seguido do activation_function.vhd.
2.4 Compilar.
2.5 Em Tools → Tlc  → Execute Macro e por fim selecionar o arquivo activation_function_tb.tcl.
2.6 Selecione X_real, clique no menu Format->Format->Analog (custom)... e altere Height para 150, Max para 8 e Min para -8.
2.7Selecione Y1_real, clique no menu Format->Format->Analog (custom)... e altere Height para 150, Max para 1 e Min para -1.
2.8 Selecione Y2_real, clique no menu Format->Format->Analog (custom)... e altere Height para 150, Max para 1 e Min para -1.


Referências
* TSMOTS, Ivan; SKOROKHODA, Oleksa; RABYK, Vasyl. Hardware implementation of sigmoid activation functions using FPGA. In: 2019 IEEE 15th International Conference on the Experience of Designing and Application of CAD Systems (CADSM). IEEE, 2019. p. 34-38.
