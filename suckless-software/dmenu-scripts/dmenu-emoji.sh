#!/bin/bash

set -e

case "$1" in
  "list")
    data=$(sed '0,/^__DATA__$/d' "$0")
    echo "$data"
    ;;
  "copy")
    input=$(tee)
    if [ ! -z "$input" ]; then
      emoji=${input: -1}
      echo -n "$emoji" | xclip -selection c
      command -v notify-send > /dev/null && notify-send -t 200 "$emoji copied!"
    fi
    ;;
  "")
    bash $0 list | dmenu -p 'Emoji: ' | bash $0 copy
    ;;
esac

exit

__DATA__
grinning face                                   😀
smiling face with open mouth                    😃
smiling face with open mouth & smiling eyes     😄
grinning face with smiling eyes                 😁
smiling face with open mouth & closed eyes      😆
smiling face with open mouth & cold sweat       😅
face with tears of joy                          😂
rolling on the floor laughing                   🤣
smiling face                                   ☺️
smiling face with smiling eyes                  😊
smiling face with halo                          😇
slightly smiling face                           🙂
upside-down face                                🙃
winking face                                    😉
relieved face                                   😌
smiling face with heart-eyes                    😍
face blowing a kiss                             😘
kissing face                                    😗
kissing face with smiling eyes                  😙
kissing face with closed eyes                   😚
face savouring delicious food                   😋
face with stuck-out tongue & winking eye        😜
face with stuck-out tongue & closed eyes        😝
face with stuck-out tongue                      😛
money-mouth face                                🤑
hugging face                                    🤗
nerd face                                       🤓
smiling face with sunglasses                    😎
clown face                                      🤡
cowboy hat face                                 🤠
smirking face                                   😏
unamused face                                   😒
disappointed face                               😞
pensive face                                    😔
worried face                                    😟
confused face                                   😕
slightly frowning face                          🙁
frowning face                                  ☹️
persevering face                                😣
confounded face                                 😖
tired face                                      😫
weary face                                      😩
face with steam from nose                       😤
angry face                                      😠
pouting face                                    😡
face without mouth                              😶
neutral face                                    😐
expressionless face                             😑
hushed face                                     😯
frowning face with open mouth                   😦
anguished face                                  😧
face with open mouth                            😮
astonished face                                 😲
dizzy face                                      😵
flushed face                                    😳
face screaming in fear                          😱
fearful face                                    😨
face with open mouth & cold sweat               😰
crying face                                     😢
disappointed but relieved face                  😥
drooling face                                   🤤
loudly crying face                              😭
face with cold sweat                            😓
sleepy face                                     😪
sleeping face                                   😴
face with rolling eyes                          🙄
thinking face                                   🤔
lying face                                      🤥
grimacing face                                  😬
zipper-mouth fce                               🤐
nauseated face                                  🤢
sneezing face                                   🤧
face with medical mask                          😷
face with thermometer                           🤒
face with head-bandage                          🤕
smiling face with horns                         😈
angry face with horns                           👿
ogre                                            👹
goblin                                          👺
pile of poo                                     💩
ghost                                           👻
skull                                           💀
skull and crossbones                           ☠️
alien                                           👽
alien monster                                   👾
robot face                                      🤖
jack-o-lantern                                  🎃
smiling cat face with open mouth                😺
grinning cat face with smiling eyes             😸
cat face with tears of joy                      😹
smiling cat face with heart-eyes                😻
cat face with wry smile                         😼
kissing cat face with closed eyes               😽
weary cat face                                  🙀
crying cat face                                 😿
pouting cat face                                😾
open hands                                      👐
raising hands                                   🙌
clapping hands                                  👏
folded hands                                    🙏
handshake                                       🤝
thumbs up                                       👍
thumbs down                                     👎
oncoming fist                                   👊
raised fist                                     ✊
left-facing fist                                🤛
right-facing fist                               🤜
crossed fingers                                 🤞
victory hand                                   ✌️
sign of the horns                               🤘
OK hand                                         👌
backhand index pointing left                    👈
backhand index pointing right                   👉
backhand index pointing up                      👆
backhand index pointing down                    👇
index pointing up                              ☝️
raised hand                                     ✋
raised back of hand                             🤚
raised hand with fingers splayed                🖐
vulcan salute                                   🖖
waving hand                                     👋
call me hand                                    🤙
flexed biceps                                   💪
middle finger                                   🖕
writing hand                                   ✍️
selfie                                          🤳
nail polish                                     💅
ring                                            💍
lipstick                                        💄
kiss mark                                       💋
mouth                                           👄
tongue                                          👅
ear                                             👂
nose                                            👃
footprints                                      👣
eye                                             👁
eyes                                            👀
speaking head                                   🗣
bust in silhouette                              👤
busts in silhouette                             👥
baby                                            👶
boy                                             👦
girl                                            👧
man                                             👨
woman                                           👩
blond-haired woman                            👱‍♀
blond-haired person                             👱
old man                                         👴
old woman                                       👵
man with Chinese cap                            👲
woman wearing turban                          👳‍♀
person wearing turban                           👳
woman police officer                          👮‍♀
police officer                                  👮
woman construction worker                     👷‍♀
construction worker                             👷
woman guard                                   💂‍♀
guard                                           💂
woman detective                             🕵️‍♀️
detective                                       🕵
woman health worker                           👩‍⚕
man health worker                             👨‍⚕
woman farmer                                  👩‍🌾
man farmer                                    👨‍🌾
woman cook                                    👩‍🍳
man cook                                      👨‍🍳
woman student                                 👩‍🎓
man student                                   👨‍🎓
woman singer                                  👩‍🎤
man singer                                    👨‍🎤
woman teacher                                 👩‍🏫
man teacher                                   👨‍🏫
woman factory worker                          👩‍🏭
man factory worker                            👨‍🏭
woman technologist                            👩‍💻
man technologist                              👨‍💻
woman office worker                           👩‍💼
man office worker                             👨‍💼
woman mechanic                                👩‍🔧
man mechanic                                  👨‍🔧
woman scientist                               👩‍🔬
man scientist                                 👨‍🔬
woman artist                                  👩‍🎨
man artist                                    👨‍🎨
woman firefighter                             👩‍🚒
man firefighter                               👨‍🚒
woman pilot                                   👩‍✈
man pilot                       …a
