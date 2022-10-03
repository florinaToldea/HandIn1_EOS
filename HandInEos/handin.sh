#!bin/bash

#FlorinaToldea

#This function turns on/off the leds 0->3.
turn_on_off_led(){
    cd /sys/class/leds/beaglebone:green:usr$1 && echo $2 > brightness
    cd /sys/class/leds/beaglebone:green:usr$1 && echo none > trigger
}

#This function turn on the led - heartbeat.
turn_led_heartbeat(){
    cd /sys/class/leds/beaglebone:green:usr$1 && echo 0 > brightness
    cd /sys/class/leds/beaglebone:green:usr$1 && echo heartbeat > trigger
}

#Setting the default triggers for default values.
turn_led_default(){
    if [ $1 == 0 ]
    then
        turn_led_heartbeat 0
    fi

    if [ $1 == 1 ]
    then
       cd /sys/class/leds/beaglebone:green:usr$1 && echo 0 > brightness
       cd /sys/class/leds/beaglebone:green:usr$1 && echo mmc0 > trigger
    fi

    if [ $1 == 2 ]
    then
       cd /sys/class/leds/beaglebone:green:usr$1 && echo 0 > brightness
       cd /sys/class/leds/beaglebone:green:usr$1 && echo none > trigger
    fi

    if [ $1 == 3 ]
    then
       cd /sys/class/leds/beaglebone:green:usr$1 && echo 0 > brightness
       cd /sys/class/leds/beaglebone:green:usr$1 && echo mmc1 > trigger
    fi
}

#Blink.
blink_led(){
    time=$(( 1000 / $2 / 2 ))
    cd /sys/class/leds/beaglebone:green:usr$1 && echo timer > trigger
    cd /sys/class/leds/beaglebone:green:usr$1 && echo $time > delay_on
    cd /sys/class/leds/beaglebone:green:usr$1 && echo $time > delay_off      
}

led_string=$(echo $1 | cut -c -3)

led_nr=$(echo $1 | cut -c 4-)


#The "..." shows that it is a string and with "$..." shows the value of the ... .
if [ "$led_string" == "all" ]
then
    if [ "$2" == "on" ]
    then
        turn_on_off_led 0 1
        turn_on_off_led 1 1
        turn_on_off_led 2 1
        turn_on_off_led 3 1
    fi

    if [ "$2" == "off" ]
    then
        for i in {0..3}
        do
            turn_on_off_led $i 0
        done
    fi

    if [ "$2" == "heartbeat" ]
    then
        for i in {0..3}
        do
            turn_led_heartbeat $i
        done
    fi

    if [ "$2" == "default" ]
    then
        for i in {0..3}
        do
            turn_led_default $i
        done
    fi

    if [ "$2" == "blink" ]
    then
        for i in {0..3}
        do 
            blink_led $i $3
        done
    fi

fi

if [ "$led_string" == "led" ]
then

    if [ "$2" == "on" ]
    then
        turn_on_off_led $led_nr 1
    fi

    if [ "$2" == "off" ]
    then
        turn_on_off_led $led_nr 0
    fi

    if [ "$2" == "heartbeat" ]
    then
        turn_led_heartbeat $led_nr
    fi

    if [ "$2" == "blink" ]
    then
        blink_led $led_nr $3
    fi

    if [ "$2" == "default" ]
    then
        turn_led_default $led_nr
    fi

fi

if [ "$1" == "--help" ]
then
    echo "Review the syntax again."
fi