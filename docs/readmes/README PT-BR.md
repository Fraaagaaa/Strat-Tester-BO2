# Strat Tester para Black Ops II

- [**Ler em galego**](https://github.com/Fraaagaaa/Strat-Tester-BO2/blob/main/docs/readmes/README%20GL.md)
- [**Leer en español**](https://github.com/Fraaagaaa/Strat-Tester-BO2/blob/main/docs/readmes/README%20ES.md)
- [**Read in english**](https://github.com/Fraaagaaa/Strat-Tester-BO2/blob/main/README.md)

## [Histórico de versões](https://github.com/Fraaagaaa/Strat-Tester-BO2/blob/main/CHANGELOG.md)

## Downloads:

- [**Baixar em espanhol**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.Espanol.rar)
- [**Baixar em inglês**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.rar)
- [**Baixar em galego**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.Galego.rar)
- [**日本語をダウンロード**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.Japanese.rar), traduzido por [AzRy](https://www.twitch.tv/azry_s)
- [**Baixar em português**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.PT-BR.rar), traduzido por [NoMoleMan](https://www.twitch.tv/nomoleman)

> [!WARNING]
> Para utilizar a versão japonesa, seu jogo precisa estar configurado em japonês.

> [!WARNING]
> Para utilizar as versões em espanhol, galego ou português, seu jogo não pode estar configurado em japonês ou polonês.

## Como instalar

- Extraia o conteúdo do arquivo baixado em `%localappdata%\Plutonium\storage\t6\mods\`.

> [!CAUTION]
> Todos os jogadores precisam ter o mod instalado. Jogadores que não tiverem o mod instalado não conseguirão utilizar o menu dentro do jogo e, consequentemente, não poderão alterar seus perks ou o HUD.

> [!WARNING]
> A sigla PT significa português, não Plutonium.

# Funcionalidades

> [!TIP]
> Todas as configurações a seguir podem ser alteradas dentro do menu de pausa.

> [!WARNING]
> Jogadores que não tiverem o mod instalado não conseguirão visualizar o menu.

> [!TIP]
> O HUD é individual para cada jogador e não depende do host.

## Configurações do jogo

- Alterar o round através de um controle deslizante.
- Botão para matar a horda.
- Botão para encerrar o round.
- Modo desenvolvedor (verificar os Master Spawners e os locais de spawn).
- NoTarget (Sem Alvo) implementado.
- Ativar/desativar power-ups (drops).
- Ativar/desativar neblina.
- Teletransportes.

## Configurações de perks

Os perks não podem ser obtidos através das máquinas de perks. Eles precisam ser selecionados diretamente no menu do Strat Tester.

## Configurações do HUD

- Timer do jogo.
- Timer do round.
- Barra de vida.
- Contador de zumbis.
- Medidor de SPH (segundos por horda).
- Exibição de zonas.
- Contador de despawners, criado por [Guy](https://github.com/ineedbots).
- Contador de zumbis dentro do campo de visão.
- Contador de zumbis muito distantes.
- Contador de vazamentos de âncora (Anchor Leaks).

### Tranzit

- Timer do ônibus.
- Localização do ônibus.
- Contador de Denizens.

### Die Rise

- Contador de kills com elevador.
- Timer da Sliquifire.

### Mob of the Dead

- Timer das armadilhas.

### Buried

- Contador de kills por disparo do Ressonador.

### Origins

- Timer dos cajados de gelo e vento.
- Contador de kills com o Tank.
- Contador de animações de queda (Tumble).
- Contador de pisoteios do Robô (Stomp).

### Mapas Survival

- Contador de usos na Mystery Box.

## Configurações específicas por mapa

### Tranzit

- Ajustar o tempo de partida do ônibus na fazenda e no diner.
- Desativar os Denizens.
- Exibir os spawners dos Denizens.
- Ativar/desativar o ônibus.
- Construir as partes do ônibus no início do jogo.
- Construir todos os itens montáveis (Buildables).

### Town

- Alterar a configuração das portas.

### Die Rise

- Trample Steam (Pisoteador) construído desde o início.
- Travar os elevadores.

### Mob of the Dead

- Afterlifes infinitos.
- Construir o escudo na cafeteria.

### Buried

- Alterar os Buildables diretamente pelo menu, sem precisar reiniciar o jogo.
- Remover as barricadas do Leroy.

### Origins

- No solo, escolher o cajado com o qual deseja começar.
- Jogador branco começa com a pá dourada e o capacete.
- Impedir que as paredes se movimentem no Crazy Place.
- O escudo é construído na igreja e no túnel de vento.
- Todos os jogadores recebem o Max Ammo da ativação dos 6 geradores.
- Todos os cajados são construídos no Crazy Place.
- Todos os portais são abertos.
- Começar com a War Machine em vez da MP40.
- Desbloquear todos os geradores.

## Configurações iniciais

- Round inicial.
- Tempo de espera inicial (Start Delay).
- Remover todas as tábuas das janelas.
- Ligar a energia.
- Abrir todas as portas.
- Conceder armas. [Confira os Loadouts](https://github.com/Fraaagaaa/Strat-Tester-BO2/blob/main/README.md#loadouts).

# Loadouts

Você pode escolher as armas fornecidas pelo mod no início do jogo.

Na pasta `zm_strattester\scriptdata\loadouts`, você encontrará os arquivos que o mod utiliza para cada mapa. Para garantir que o formato seja válido, eles devem seguir estas regras:

1. Primeira linha: Insira o código das armas que deseja receber (ex.: `ray_gun_zm`).
2. Segunda linha: Insira a arma que deseja utilizar no slot do Mule Kick (Coz).
3. Terceira linha: Insira o equipamento que deseja receber (tudo aquilo que utiliza o D-pad ao jogar com controle).
4. Quarta linha: Insira a arma corpo a corpo (melee) que deseja receber (ex.: `tazer_knuckles_zm`).
5. Nenhuma linha pode ficar em branco. Caso não queira receber um item específico, escreva `undefined`.

# Comandos de chat

- `!nuke`          gera um power-up Nuke em cima do jogador.
- `!x2`            gera um power-up Double Points em cima do jogador.
- `!max`           gera um power-up Max Ammo em cima do jogador.
- `!insta`         gera um power-up Insta Kill em cima do jogador.
- `!sale`          gera um power-up Fire Sale em cima do jogador.
- `!blood`         gera um power-up Zombie Blood em cima do jogador.
- `!perk`          gera um power-up de perk aleatório em cima do jogador.
- `!tp`            teletransporta o jogador para o local desejado.
- `!tpc`           teletransporta o jogador para as coordenadas desejadas.
- `!points`        define a pontuação do jogador. Pode ser utilizado com `inf` para obter pontos infinitos.
- `!remainig`      define a quantidade de zumbis restantes no round.
- `!gen x`         ativa/desativa o gerador de número x em Origins.

# Para desenvolvedores

Este mod define `level.strat_tester` como `true` dentro de `init()`. Entretanto, uma maneira melhor de verificar se o mod está carregado é consultar a dvar `fs_game`.

Para evitar a mensagem "Unknown command" do Strat Tester, adicione seus comandos em `level.chatcommands` ou `level.chatcommandsaliases`. Por exemplo, utilize o seguinte código:

```cpp
addCommands(commands, alias)
{
    if(!isdefined(alias))
        alias = false;

    if(!alias)
    {
        foreach(command in commands)
            level.chatcommands[level.chatcommands.size] = "!" + command;
    }
    else
    {
        foreach(command in commands)
            level.chatcommandsaliases[level.chatcommandsaliases.size] = "!" + command;
    }
}

f()
{
    if(!isdefined(level.chatcommands))
        level.chatcommands = [];
    if(!isdefined(level.chatcommandsaliases))
        level.chatcommandsaliases = [];

    addCommands(array("zc", "tzc"), true);
    addCommands(array("zombiecount", "totalzombiecount"), false);
}
```
# Compilar a partir do código-fonte

Dependências:
- [Open Asset Tools](https://openassettools.dev/)
- [WinRAR](https://www.rarlab.com/download.htm)

Pré-requisitos:
- Ter o OAT instalado em `C:\OAT`.
- Ter o `WinRAR.exe` instalado em `C:\Program Files\WinRAR\WinRAR.exe`.
- Ter o Plutonium instalado em `%LOCALAPPDATA%`.
- **ALTERNATIVAMENTE**, você pode modificar [estas linhas no builder.bat](https://github.com/Fraaagaaa/Strat-Tester-BO2/blob/main/builder.bat#L3-L5).

Compilação:
1. Crie o diretório `english\localizedstrings`.
2. A partir de `localized\language`, copie os arquivos do idioma de sua preferência para `english\localizedstrings`.
3. Adicione o arquivo `localized\st_watermark.str` ao diretório `english\localizedstrings`.
4. Execute o `builder.bat`.

# Agradecimentos

- [NoMoleMan](https://www.twitch.tv/nomoleman) por ser o principal tester e traduzir os menus para português.
- [Guy](https://github.com/ineedbots) por criar o script de teste de despawners.
- [5and5](https://github.com/5and5) por criar o Strat Tester original e me ajudar há 5 anos, quando comecei a desenvolver mods para Black Ops.
- [Hadi77KSA](https://github.com/Hadi77KSA) por criar o script para ligar as portas do Afterlife.
- [MJ](https://github.com/mjmodz) por ajudar com o menu de seleção de perks.
- [Astrox](https://www.twitch.tv/lastroxl) pelos setups sem energia (No Power).
- [AzRy](https://www.twitch.tv/azry_s) por traduzir os menus para japonês.
- [Jbleezy](https://github.com/Jbleezy) por criar a exibição de superaquecimento da Jet Gun e do Paralyzer no HUD em seu [mod BO2 Reimagined](https://github.com/Jbleezy/BO2-Reimagined).