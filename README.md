# LongestEdgeBisection2D

Este repositório contém uma aplicação C++ para realizar a bissecção do maior lado em 2D.

## Pré-requisitos

Certifique-se de ter o seguinte instalado em seu sistema:

- CMake (versão 3.1 ou superior)
- Compilador C++ compatível com o padrão C++11
- GLFW

## Compilação e Execução

Para compilar a aplicação e gerar o executável, siga estas etapas no terminal:

1. Crie um diretório de compilação e acesse-o:
    ```
    mkdir build && cd build
    ```

2. Execute o CMake para configurar o build:
    ```
    cmake ..
    ```

3. Compile o código fonte com o `make`:
    ```
    make
    ```

Após a compilação bem-sucedida, você pode executar a aplicação com o seguinte comando:
    ```
      ./terrain
    ```



## Detalhes do CMakeLists.txt

O arquivo `CMakeLists.txt` contém instruções para configurar e compilar o projeto. Ele utiliza o CMake para gerar os arquivos de compilação e vinculação necessários para construir a aplicação. O arquivo também define as dependências e configurações específicas do projeto.

## Observações

- O projeto utiliza várias bibliotecas, como GLFW, ImGui, STB, entre outras. Certifique-se de que elas estão corretamente incluídas nos subdiretórios correspondentes.
- O arquivo `terrain` é o executável gerado após a compilação bem-sucedida do projeto.
- Certifique-se de ajustar as configurações do CMake e as dependências conforme necessário para o seu ambiente de desenvolvimento.
