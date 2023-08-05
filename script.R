df <- read.csv("tyhoon-bst.csv", header=TRUE)

head(df)
tail(df)

tdf <- df
tdf <- subset(df, df[,11]>0) #最大風速34kt以上
tdf <- subset(df, df[,18]==1) #上陸のみ
tdf <- subset(df, df[,18]==1 & df[,11]>0) #最大風速34kt以上/上陸のみ
head(tdf)
tail(tdf)


pairs(tdf[,c(3,4,5)], panel = panel.smooth)

#--------------------------------------

plot(tdf$緯度, tdf$中心気圧, col=1, type = "p", main="緯度と中心気圧の関係")
abline(v=35.5, col="red") #東京横浜
abline(v=33.5, col="red", lty=2)　#紀伊半島
# abline(v=33.25, col="red", lty=2)　#室戸岬
abline(v=31, col="red", lty=2)　#大隅半島
abline(v=30, col="red")　#30度
abline(v=26.2, col="red", lty=2)　#那覇市
abline(h=911.8, col="red") #室戸台風
abline(h=929.6, col="red") #伊勢湾台風
abline(h=940, col="red", lty=2)　#
abline(h=965, col="red", lty=2)　#


tdf2 <- subset(df, df[,1]=="1979T20_TIP")
lines(tdf2$緯度, tdf2$中心気圧, col=4, lwd=4)

tdf2 <- subset(df, df[,1]=="1973T15_NORA")
lines(tdf2$緯度, tdf2$中心気圧, col=4, lwd=4)

tdf2 <- subset(df, df[,1]=="1975T20_JUNE")
lines(tdf2$緯度, tdf2$中心気圧, col=4, lwd=4)

tdf2 <- subset(df, df[,1]=="1958T22_IDA")
lines(tdf2$緯度, tdf2$中心気圧, col=4, lwd=4)
lines(tdf2$緯度, tdf2$中心気圧, col=1, lwd=2, lty=2)

tdf2 <- subset(df, df[,1]=="1959T15_VERA")
lines(tdf2$緯度, tdf2$中心気圧, col=2, lwd=4)

tdf2 <- subset(df, df[,1]=="1961T18_NANCY")
lines(tdf2$緯度, tdf2$中心気圧, col=7, lwd=4)

#--------------------------------------

sub <- subset(df, df[,3]>30)
sub <- subset(sub, sub[,5]<=930)
write.csv(sub, "tyhoon-bst-subset-30N-930hPa.csv", row.names = FALSE)

#--------------------------------------


# プロットと同時に単回帰分析を行う関数を作成する
splot <- function(x, y, col, main) {
  plot(x, y, col=col, main=main)
  m <- lm(y ~ x)
  abline(m)
  return(summary(m)) 
}

pcol = tdf[,18] + 1

#splot(tdf[,8], tdf[,10], col=1, type = "l", main="緯度と中心気圧の関係")
#points(tdf[,8], tdf[,10], col=pcol)

plot(tdf[,8], tdf[,10], col=1, type = "p", main="緯度と中心気圧の関係")
abline(v=35.5, col="red") #東京横浜
abline(v=33.5, col="red", lty=2)　#紀伊半島
abline(v=33.25, col="red", lty=2)　#室戸岬
abline(v=31, col="red", lty=2)　#大隅半島
abline(v=30, col="red")　#30度
abline(v=26.2, col="red", lty=2)　#那覇市
abline(h=911.8, col="red") #室戸台風
abline(h=929.6, col="red") #伊勢湾台風

tdf2 <- subset(df, df[,18]==1) #上陸のみ
points(tdf2[,8], tdf2[,10], col=4, pch=3)


plot(tdf[,8], tdf[,13], col=1, type = "p", main="緯度と50KT長径の関係")
abline(v=35.5, col="red") #東京横浜
abline(v=33.5, col="red", lty=2)　#紀伊半島
abline(v=33.25, col="red", lty=2)　#室戸岬
abline(v=31, col="red", lty=2)　#大隅半島
abline(v=30, col="red")　#30度
abline(v=26.2, col="red", lty=2)　#那覇市
abline(h=911.8, col="red") #室戸台風
abline(h=929.6, col="red") #伊勢湾台風

tdf2 <- subset(df, df[,18]==1) #上陸のみ
points(tdf2[,8], tdf2[,13], col=4, pch=3)

# https://www.bousai.go.jp/kyoiku/kyokun/kyoukunnokeishou/rep/1959_isewan_typhoon/index.html

sub <- subset(df, df[,8]>30)
sub <- subset(sub, sub[,10]<=940)
write.csv(sub, "tyhoon-subset-30N-940hPa.csv", row.names = FALSE)


splot(tdf[,8], tdf[,11], col=pcol, main="緯度と最大風速の関係")
splot(tdf[,8], tdf[,13], col=pcol, main="緯度と50KT長径の関係")
splot(tdf[,10], tdf[,11], col=pcol, main="中心気圧と最大風速の関係")

splot(tdf[,11], tdf[,13], col=pcol, main="最大風速と50KT長径の関係")
splot(tdf[,10], tdf[,13], col=pcol, main="中心気圧と50KT長径の関係")



splot(tdf[,13], tdf[,14], col=pcol, main="50KT長径と50KT短径の関係")
splot(tdf[,13], tdf[,16], col=pcol, main="50KT長径と30KT長径の関係")

pairs(tdf[,c(2,8,9,10,11,13)], panel = panel.smooth)

boxplot(tdf[,10] ~ tdf[,2], main="月と中心気圧の関係")
boxplot(tdf[,11] ~ tdf[,2], main="月と最大風速の関係")
boxplot(tdf[,10] ~ tdf[,1],  main="年と中心気圧の関係")

write.csv(tdf, "tyhoon-subset.csv", row.names = FALSE)

# -------------------------
library(tidyverse)

tdf <- df %>% group_by(台風名)

plot(tdf$緯度, tdf$中心気圧, type = "l")

tdf %>%
  ggplot() + 
  geom_line(aes(x = 緯度, y = 中心気圧))










