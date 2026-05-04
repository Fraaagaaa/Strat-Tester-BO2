# Strat Tester para Black Ops II

## Downloads:

- [**Baixar em espanhol**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.Espanol.rar)
- [**Download em inglês**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.rar)
- [**Baixar em galego**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.Galego.rar)
- [**Baixar em português**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.PT-BR.rar), traduzido por [NoMoleMan](https://www.twitch.tv/nomoleman)

## Como instalar

- Extraia o arquivo em `%localappdata%\Plutonium\storage\t6\mods`.

## Mudanças gerais 
- Perks são concedidos ao spawnar 
- Armas são concedidas ao spawnar 
- Todas as portas estão abertas (exceto as necessárias para uma strat específica) 
- O jogo começa no round 100 
- Temporizadores (Timers) do jogo, do round e de armadilhas
- Barra de vida
- Contador de zumbis
- Exibição de zona 
- Medidor de segundos por horda (SPH)
- Escolher para onde a Box pode ser movida na maioria dos mapas
- Power-ups (Drops) podem ser desativados
- NoTarget (Sem Alvo) implementado 
- A neblina pode ser desativada 
- Rastreador de despawn de zumbis feito por [Guy](https://github.com/ineedbots)

## Mudanças por mapa
### Tranzit
- Adicionado um terceiro timer para o ônibus
- Adicionada exibição da localização do ônibus
- Jogadores recebem uma notificação quando um denizen nasce 
- É possível escolher o tempo de partida do ônibus na fazenda 

### Town (Cidade)
- 2 configurações (setups) de jogo 
- Porta do Juggernog aberta (Porta do Speed Cola fechada) 
- Porta do Speed Cola aberta (Porta do Juggernog fechada) 

### Nuketown
- Todos os perks caem do céu no início do jogo 
- Pode reiniciar automaticamente para o PAP (Pack-a-Punch) na casa verde

### Die Rise
- Trample Steam construído desde o começo 
- Rastreador de kills de elevador

### MOTD (Mob of the Dead)
- Escudo construído desde o começo do jogo na cafeteria 
- Afterlives infinitos
- Todas as peças já estão coletadas no início do jogo 

### Buried
- Duas configurações (setups) de equipamentos: 
    - Ressonador no jug, Turbina na igreja e Trample Steam no saloon (padrão) 
    - Ressonador no saloon, Turbina na igreja e Trample Steam no jug 
- Contador de kills com Ressonador 

### Origins
- Jogador branco começa com pá e capacete dourado 
- Jogadores podem chamar o tank do gerador 2 desde o começo 
- Escudo já spawnado na igreja 
- Recompensa de max ammo concedida para cada jogador 
- Todos os cajados com upgrade são colocados no Crazy Place 
- Todos os portais estão abertos 
- Rastreadores para zumbis pisoteados e derrubados pelos Robôs 
- Rastreador para as eliminações com o tank

## Loadouts
Você pode escolher as armas fornecidas pelo mod no início do jogo.
Na pasta `zm_strattester\scriptdata\loadouts`, você encontrará os arquivos que o mod lê para cada mapa. Para garantir que o formato seja válido, ele deve seguir estas regras:

1. Primeira linha: Insira o código das armas que você deseja receber (ex: `ray_gun_zm`).
2. Segunda linha: Insira a arma que você quer para o slot do Mule Kick (Coz).
3. Terceira linha: Insira o equipamento que você deseja receber (tudo que usa o D-pad ao jogar com controle).
4. Quarta linha: Insira a arma melee que você deseja receber (ex: `tazer_knuckles_zm`).
5. Nenhuma linha pode ficar em branco: Se você não quiser um item específico, deve escrever `undefined`.

## Comandos de chat 

### Geral 
- `!nuke`          gera um power-up nuke (Kabum) em cima do jogador 
- `!x2`            gera um power-up double points em cima do jogador 
- `!max`           gera um power-up max ammo em cima do jogador 
- `!insta`         gera um power-up insta kill em cima do jogador
- `!sale`          gera um power-up fire sale em cima do jogador 
- `!blood`         gera um power-up zombie blood (sangue de zumbi) em cima do jogador
- `!perk`          gera um power-up de perk aleatório em cima do jogador 
- `!tp`            teleporta o jogador para o local desejado 
- `!tpc`           teleporta o jogador para as coordenadas desejadas 

### Origins
- `!gen x`       ativa ou desativa gerador número x 

# Agradecimentos para:
- [NoMoleMan](https://www.twitch.tv/nomoleman) por ser o principal tester e traduzir os menus para português.
- [Guy (Um dos desenvolvedores do Plutonium)](https://github.com/ineedbots) por criar o script de teste de despawn.
- [5and5](https://github.com/5and5) por criar o strat tester original e ajudar há 5 anos quando comecei a fazer mods de Black Ops.
- [Hadi77KSA](https://github.com/Hadi77KSA) por criar o script para ligar as portas de afterlife. 
- MJ por ajudar com o menu de seleção de perks.
