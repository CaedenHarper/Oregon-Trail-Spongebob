# Caeden Harper q:^)
.intel_syntax noprefix
.data

# IMMUTABLE VARIABLES

# helper strings
newline:
    .ascii "\n\0"
percent:
    .ascii "%\0"
buffer:
    .ascii "--------------------\0"
buffer_long:
    .ascii "----------------------------------------\0"

# resource strings
rules:
    .ascii "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n"
    .ascii " Spongebob: Rock Pizza Delivery \n"
    .ascii "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n\n"
    .ascii "Rules: \n"
    .ascii "* You have to travel 1000 miles in 30 days.\n"
    .ascii "* You have: \n"
    .ascii "    * A rock: if its height is 0, you can not ride it\n"
    .ascii "    * Food: You will eat 5-10 Krabby Patties per day.\n"
    .ascii "    * Health: Your health drops 5-10% each day. If you are starving, it drops 10-20%.\n"
    .ascii "* You can: \n"
    .ascii "    1. Sleep: Spongebob will regain 30-60% health, and Patrick will build the rock up 10-50%.\n"
    .ascii "       Beware! You will lose 1-4 days!\n"
    .ascii "    2. Call the Krusty Krab: You can find 0-40 Krabby Patties. It takes 1 day.\n"
    .ascii "    3. Keep Traveling: You advance 5-100 miles, but your rock loses 10-25% height.\n\n"
    .ascii "You lose if time runs out or if your health drops to 0%.\n\n\0"
distance_left:
    .ascii "Distance Left  : \0"
rock_left:
    .ascii "Rock's Height  : \0"
health_left:
    .ascii "Your Health    : \0"
food_left:
    .ascii "Krabby Patties : \0"
miles:
    .ascii " miles\0"

# choice strings
choice_prompt:
    .ascii "Would you like to...\n--------------------\n1. Rest\n2. Call the Krusty Krab\n3. Travel?\nYour Choice: \0"
choice_bad:
    .ascii "That choice is not valid. Try again!\n\0"

# rest strings
resting:
    .ascii "You choose to rest...\0"
rock_gain1:
    .ascii "Patrick has built the rock up by \0"
rock_gain2:
    .ascii "% height.\0"
health_gain1:
    .ascii "You have gained \0"
health_gain2:
    .ascii "% health.\0"
delay_gain1:
    .ascii "But it cost you \0"
delay_gain2:
    .ascii " day(s)!\0"

# call strings
calling:
    .ascii "You choose to call the Krusty Krab...\0"
food_gain1:
    .ascii "You ordered \0"
food_gain2:
    .ascii " Krabby Patties.\0"

# travel strings
travelling:
    .ascii "You choose to travel...\0"
distance_gain1:
    .ascii "You advanced \0"
distance_gain2:
    .ascii " miles.\0"
rock_loss1:
    .ascii "But your rock lost \0"
rock_loss2:
    .ascii "% height!\0"
rock_fail:
    .ascii "Your rock is too short to travel!\0"

# time passage strings

day_gain:
    .ascii "JOURNEY DAY \0"
food_loss1:
    .ascii "You ate \0"
food_loss2:
    .ascii " pounds of food.\0"
health_loss1:
    .ascii "You lost \0"
health_loss2:
    .ascii " health.\0"
starving_loss1:
    .ascii "YOU ARE STARVING! You lost \0"
starving_loss2:
    .ascii " health.\0"

# game over strings

gameover:
    .ascii "game over\0"
gameover_health:
    .ascii "You ran out of health!\0"
gameover_days:
    .ascii "You ran out of time!\0"
win:
    .ascii "you win\0"

# MUTABLE VARIABLES
distance:
    .quad 250

# rock height (energy)
rock:
    .quad 100
health:
    .quad 100
food:
    .quad 30
day:
    .quad 0
delay:
    .quad 0

.text
.global _start
_start:
    lea rbx, rules
    call PrintStr

# main loop
Main:   
    # print resources
    call Resources
ChoiceBad:
    # ask question, store response in r8
    lea rbx, choice_prompt
    call PrintStr
    call ScanDec
    mov r8, rbx

    # print newline before validating choices
    lea rbx, newline
    call PrintStr

    # validate choice
    cmp r8, 1
    je ChoiceRest

    cmp r8, 2
    je ChoiceCall

    cmp r8, 3
    je ChoiceTravel

    # choice is not valid
    lea rbx, choice_bad
    call PrintStr
    lea rbx, buffer
    call PrintStrLine

    jmp ChoiceBad
ChoiceRest:
    lea rbx, resting
    call PrintStrLine

    # add rock height

    # r9 = random number between 10 and 50
    mov rbx, 41 
    call GetRandom
    add rbx, 10
    mov r9, rbx
    
    lea rbx, rock_gain1
    call PrintStr

    mov rbx, r9
    call PrintDec

    lea rbx, rock_gain2
    call PrintStrLine

    mov rbx, rock
    add rbx, r9
    # make sure rbx <= 100
    cmp rbx, 100
    jg RockCeiling
    jmp RockCeilingEnd
    RockCeiling:
    mov rbx, 100
    RockCeilingEnd:
    mov rock, rbx

    # add health

    # r9 = random number between 30 and 60
    mov rbx, 31
    call GetRandom
    add rbx, 30
    mov r9, rbx
    
    lea rbx, health_gain1
    call PrintStr

    mov rbx, r9
    call PrintDec

    lea rbx, health_gain2
    call PrintStrLine

    mov rbx, health
    add rbx, r9
    # make sure rbx <= 100
    cmp rbx, 100
    jg HealthCeiling
    jmp HealthCeilingEnd
    HealthCeiling:
    mov rbx, 100
    HealthCeilingEnd:
    mov health, rbx

    # add delay

    # r9 = random number between 1 and 4
    mov rbx, 4
    call GetRandom
    add rbx, 1
    mov r9, rbx
    
    lea rbx, delay_gain1
    call PrintStr

    mov rbx, r9
    call PrintDec

    lea rbx, delay_gain2
    call PrintStrLine

    mov delay, r9

    # jump to end
    jmp ChoiceEnd
ChoiceCall:
    lea rbx, calling
    call PrintStrLine

    # add food

    # r9 = random number between 0 and 40
    mov rbx, 41 
    call GetRandom
    mov r9, rbx
    
    lea rbx, food_gain1
    call PrintStr

    mov rbx, r9
    call PrintDec

    lea rbx, food_gain2
    call PrintStrLine

    mov rbx, food
    add rbx, r9
    # make sure rbx <= 100
    cmp rbx, 100
    jg FoodCeiling
    jmp FoodCeilingEnd
    FoodCeiling:
    mov rbx, 100
    FoodCeilingEnd:
    mov food, rbx

    # set delay = 1
    movq delay, 1

    # jump to end
    jmp ChoiceEnd
ChoiceTravel:
    lea rbx, travelling
    call PrintStrLine

    # if rock < 1, can not travel; if rock >= 1, can travel
    mov rbx, rock
    cmp rbx, 1
    jge TravelYes

    # can not travel condition
    lea rbx, rock_fail
    call PrintStrLine

    # jump to skip true condition
    jmp ChoiceEnd
TravelYes:
    # add miles

    # r9 = random number between 5 and 100
    mov rbx, 96
    call GetRandom
    add rbx, 5
    mov r9, rbx
    
    lea rbx, distance_gain1
    call PrintStr

    mov rbx, r9
    call PrintDec

    lea rbx, distance_gain2
    call PrintStrLine

    mov rbx, distance
    sub rbx, r9
    mov distance, rbx

    # subtract rock

    # r9 = random number between 10 and 25
    mov rbx, 16
    call GetRandom
    add rbx, 10
    mov r9, rbx
    
    lea rbx, rock_loss1
    call PrintStr

    mov rbx, r9
    call PrintDec

    lea rbx, rock_loss2
    call PrintStrLine

    mov rbx, rock
    sub rbx, r9
    # make sure rbx >= 0
    cmp rbx, 0
    jl RockFloor
    jmp RockFloorEnd
    RockFloor:
    mov rbx, 0
    RockFloorEnd:
    mov rock, rbx

    # jump to end
    jmp ChoiceEnd

    # set delay = 1
    movq delay, 1
ChoiceEnd:
    lea rbx, buffer_long
    call PrintStrLine
    # day += 1
    mov rbx, day
    add rbx, 1
    mov day, rbx

    # journey day {day}
    lea rbx, day_gain
    call PrintStr
    mov rbx, day
    call PrintDecLine

    # game over if day > 30
    mov rbx, day
    cmp rbx, 30
    jg GameOverDays

    # if food > 0, not starving
    mov rbx, food
    cmp rbx, 0
    # jumping to a seperate "FoodStarving" is not necessary but makes it easier to read (imo)
    jg FoodNotStarving
    jmp FoodStarving
FoodNotStarving:
    # lose food

    # r9 = random number from 5 to 10
    mov rbx, 6
    call GetRandom
    add rbx, 5
    mov r9, rbx

    lea rbx, food_loss1
    call PrintStr

    mov rbx, r9
    call PrintDec

    lea rbx, food_loss2
    call PrintStrLine

    mov rbx, food
    sub rbx, r9
    # make sure rbx >= 0
    cmp rbx, 0
    jl FoodFloor
    jmp FoodFloorEnd
    FoodFloor:
    mov rbx, 0
    FoodFloorEnd:
    mov food, rbx

    # lose health

    # r9 = random number from 5 to 10
    mov rbx, 6
    call GetRandom
    add rbx, 5
    mov r9, rbx

    lea rbx, health_loss1
    call PrintStr

    mov rbx, r9
    call PrintDec
    lea rbx, percent
    call PrintStr

    lea rbx, health_loss2
    call PrintStrLine

    mov rbx, health
    sub rbx, r9
    # make sure rbx >= 0
    cmp rbx, 0
    jl HealthFloor
    jmp HealthFloorEnd
    HealthFloor:
    mov rbx, 0
    HealthFloorEnd:
    mov health, rbx

    # jump over starving code
    jmp FoodAfter
FoodStarving:
    # lose health

    # r9 = random number from 20 to 30
    mov rbx, 11
    call GetRandom
    add rbx, 20
    mov r9, rbx

    lea rbx, starving_loss1
    call PrintStr

    mov rbx, r9
    call PrintDec
    lea rbx, percent
    call PrintStr

    lea rbx, starving_loss2
    call PrintStrLine

    mov rbx, health
    sub rbx, r9
    # make sure rbx >= 0
    cmp rbx, 0
    jl StarvingFloor
    jmp StarvingFloorEnd
    StarvingFloor:
    mov rbx, 0
    StarvingFloorEnd:
    mov health, rbx

    # jump here is not necessary but it makes it easier to read (imo)
    jmp FoodAfter
FoodAfter:
    lea rbx, buffer_long
    call PrintStrLine
    # delay--
    mov rbx, delay
    sub rbx, 1
    mov delay, rbx

    # loop days if delay > 0
    cmp rbx, 0
    jg ChoiceEnd

    # game over if health <= 0
    mov rbx, health
    cmp rbx, 0
    jle GameOverHealth

    # win if distance <= 0
    mov rbx, distance
    cmp rbx, 0
    jle Win

    # else, go to main game loop
    jmp Main
GameOverHealth:
    lea rbx, gameover_health
    call PrintStrLine

    # jump to general game over to end game
    jmp GameOver
GameOverDays:
    lea rbx, gameover_days
    call PrintStrLine

    # jump to general game over to end game
    jmp GameOver
GameOver:
    lea rbx, gameover
    call PrintStrLine

    jmp Exit
Win:
    lea rbx, win
    call PrintStrLine

    jmp Exit
Exit:
    call ExitProgram

# HELPER FUNCTIONS:
# prints string at the address in rbx with a newline
PrintStrLine:
    call PrintStr
    lea rbx, newline
    call PrintStr
    ret

# prints decimal in rbx with a newline
PrintDecLine:
    call PrintDec
    lea rbx, newline
    call PrintStr
    ret

# prints decimal in rbx with a percentage sign and newline
PrintPercent:
    call PrintDec
    lea rbx, percent
    call PrintStr
    lea rbx, newline
    call PrintStr
    ret

# print resources
Resources:
    # print distance
    lea rbx, distance_left
    call PrintStr

    mov rbx, distance
    call PrintDec
    
    # add units
    lea rbx, miles
    call PrintStrLine

    # print rock height
    lea rbx, rock_left
    call PrintStr

    mov rbx, rock
    call PrintPercent

    # print health
    lea rbx, health_left
    call PrintStr

    mov rbx, health
    call PrintPercent

    # print food
    lea rbx, food_left
    call PrintStr

    mov rbx, food
    call PrintDecLine

    # add buffer line after
    lea rbx, buffer
    call PrintStrLine

    ret
