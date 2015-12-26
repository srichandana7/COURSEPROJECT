a<-read.table("UCI HAR Dataset/test/X_test.txt")
b<-read.table("UCI HAR Dataset/test/y_test.txt")
c<-read.table("UCI HAR Dataset/test/subject_test.txt")


d<-read.table("UCI HAR Dataset/train/X_train.txt")
e<-read.table("UCI HAR Dataset/train/y_train.txt")
f<-read.table("UCI HAR Dataset/train/subject_train.txt")


bindx<-rbind(a,d)
bindy<-rbind(b,e)
bindsubject<-rbind(c,f)


names(bindx)
names(bindy)


readfeature<-read.table("UCI HAR Dataset/features.txt")
readfeature[,2]

names(bindx)<-readfeature[,2]

readactivity<-read.table("UCI HAR Dataset/activity_labels.txt")
readactivity[,2]

names(bindy)<-("activity")
names(bindsubject)<-("subject")

p<-cbind(bindx, bindy, bindsubject)
p

q<-grep(".*Mean.*|.*Std.*", names(p), ignore.case=TRUE) 
q
t<-p[,c(q,562,563)]
t
names(t)


t$activity<-as.character(t$activity)

for (i in 1:6) {
        t$activity[t$activity==i]<-as.character(readactivity[i,2])
}

names(t)<-gsub("Acc", "Accelerometer", names(t))
names(t)<-gsub("Gyro", "Gyrometer", names(t))
names(t)<-gsub("-mean()", "Mean", names(t))
names(t)<-gsub("-std()", "STD", names(t))
names(t)<-gsub("-freq()", "Frequency", names(t))



t$activity<-as.factor(t$activity)
t$subject<-as.factor(t$subject)

t<-data.table(t)
tidydata<-aggregate(.~subject + activity, t, mean)
write.table(tidydata,"tidy.txt",row.names=FALSE)

