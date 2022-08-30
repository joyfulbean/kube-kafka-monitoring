### install 1.8 version java for mac
https://www.azul.com/downloads/?version=java-8-lts&os=macos&architecture=arm-64-bit&package=jdk

### install 1.8 version java for linux
sudo apt-get install openjdk-8-jdk

/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home

### install 1.8 version java for mac
https://www.azul.com/downloads/?version=java-8-lts&os=macos&architecture=arm-64-bit&package=jdk

### install 1.8 version java for linux
sudo apt-get install openjdk-8-jdk

### check java path 
cd /Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home

### put java path in ~/.zshrc
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home
export PATH=${PATH}:$JAVA_HOME/bin
export JMETER_HOME=/opt/homebrew/opt/jmeter/libexec

### update the env
source ~/.zshrc

### check java version
java -version

### install mvn for mac 
brew install mvn

### clone the project 
git clone https://github.com/GSLabDev/pepper-box.git

### build project 
mvn clean install -Djmeter.version=3.0 -Dkafka.version=0.9.0.1

### install jmeter 
brew install jmeter

### copy jar file to jmeter_home/lib.ext
cp ./pepper-box/target/pepper-box-1.0.jar $JMETER_HOME/lib/ext
cp -R ./pepper-box/target/classes $JMETER_HOME/lib/ext

### open jmeter 
open /opt/homebrew/bin/jmeter

############# kafka producer set in jmeter ############
- use my default set: pepper_box.jmx

[default set is configured as below]
0) mac options > plugin manager > search kafka and add all related objects 

1) Java Request 
Thread group -> Add -> Sampler -> Java Request
com.gslab.pepper.sampler.PepperBoxKafkaSampler
bootstrap.servers: public ec2 ip: 32400, public ec2 ip: 32401 ... so on 
kafka.topic.name : topic name

2)Pepper-Box PlainText Config
testplan -> Add -> Thread group -> Add -> Config Element -> Pepper-Box PlainText

ClassName:com.gslab.pepper.sampler.PepperBoxKafkaSampler
Message Placeholder Key: MyMsg

{
	"messageId":{{SEQUENCE("messageId", 1, 1)}},
	"messageBody":"{{RANDOM_ALPHA_NUMERIC("abcedefghijklmnopqrwxyzABCDEFGHIJKLMNOPQRWXYZ", 100)}}",
	"messageCategory":"{{RANDOM_STRING("Finance", "Insurance", "Healthcare", "Shares")}}",
	"messageStatus":"{{RANDOM_STRING("Accepted","Pending","Processing","Rejected")}}",
}

3)Pepper-Box Serialized Config

testplan-> Add -> Thread group -> Add -> Config Element -> Pepper-Box Serialized Config
Message Placeholder Key: MyMsg
ClassName: com.gslab.pepper.Message

### load generator
java -cp pepper-box-1.0.jar  com.gslab.pepper.PepperBoxLoadGenerator --schema-file <schema file absolute path> --producer-config-file <producer properties absoulte path>  --throughput-per-producer <throughput rate per producer> --test-duration <test duration in seconds> --num-producers <number of producers>


############# kafka consumer set in jmeter ############
1)JSR223 Sampler-Kafka Consumer

brew install kafka

## references
1)[java 설치](https://systorage.tistory.com/entry/MacOS-M1칩에서-open-jdk-8버전18-설치)
2)[jmeter 카프카 설정1](https://iwconnect.com/testing-kafka-with-jmeter/)
3)[jmeter 카프카 설정2](https://www.blazemeter.com/blog/kafka-testing)
4)[jmeter 설치](https://ehdrms2034.github.io/성능테스트툴-Apache-Jmeter-설치부터-간단한-사용까지/!!)
5)[jmeter-kafka template github](https://github.com/GSLabDev/pepper-box)


