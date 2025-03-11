Geração Procedural de Terreno em Multirresolução

Geração Procedural de Terreno em Multirresolução
================================================

Este repositório contém o código da **aplicação gráfica** referente ao meu Trabalho de Conclusão de Curso "Geração Procedural de Terreno em Multirresolução" para renderização de terrenos utilizando a estrutura de dados **Concurrent Binary Tree**, **Tessellation Shader** e o **ruído Fractal Brownian Motion** para geração procedural de altura. O projeto faz uso de frameworks e bibliotecas como o **OpenGL**, **GLFW**, **GLAD**, **ImGui**, **SDL2** e **SimplexNoise**.

* * *

Implementações
-----------

* Renderização de terrenos com subdivisão adaptativa
* Uso de shaders avançados para controle de tesselação
* Implementação de LOD dependente
* Suporte a texturas e mapas de altura
* Interface de usuário via **ImGui** para ajustes em tempo real

* * *

Instalação
------------------

A aplicação foi testada em um ambiente Linux. Porém pode ser instalado em outros sistemas operacionais que possuem instalado previamente o compilador GCC/Clang (Linux/macOS) ou MSVC (Windows).

*   **Bibliotecas Necessárias:**

*   OpenGL 4.5+
*   GLFW
*   GLAD
*   SDL2
*   ImGui
*   stb\_image / stb\_image\_write (para carregamento de texturas)

* * *

📥 Como Clonar o Repositório
----------------------------

    Clone o repositório
    $ git clone https://github.com/iagoesp/TCC_LEB.git
    
    Entre no diretório do projeto
    $ cd TCC_LEB
    
    

Em seguida, execute o comando abaixo para baixar os submódulos e dependências:

    git submodule update --init --recursive
    
    

* * *

🔧 Configuração do Ambiente
---------------------------

### 🐧 Linux (Ubuntu/Debian)

    $ sudo apt update
    $ sudo apt install build-essential cmake git libglfw3-dev libglew-dev libsdl2-dev libglm-dev libxinerama-dev libxcursor-dev libxi-dev
    
* * *

🏗️ Compilação
--------------

### Usando CMake

    # Criar diretório para build
    $ mkdir build && cd build
    
    # Gerar arquivos de build
    cmake ..
    
    # Compilar o projeto
    make

* * *

🎮 Como Executar
----------------

    Rode no terminal na pasta build
    ./terrain
    
    

* * *

🕹️ Controles
-------------


### Movimentação da câmera

* Teclas WASD

### Rotaciona a câmera


* Mouse Esquerdo

### Move a câmera no espaço

* Mouse Direito


### Zoom in/out

* Scroll do Mouse

### Ativa/Desativa HUD

* ESC

### Recarrega os shaders

* R
