
#This is a script to look at the overlap between overlapping domain and determine if they are separate domains or not
#The script will take the output of the HMM scan and determine the overlap between the domains
########################################################################################
#####################################################################################################################################################################
rm(list=ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

########################################################################################
########################################################################################
# Load the data
#load the HMM scan output
dat <- read.table('VV_hmmscan_modified.tlout',head=F,sep='\t',stringsAsFactors = FALSE)
head(dat)
region <- unique(dat[,c(1,4)])
head(region)  
ov <- c()

Overlap <- function(left1,right1,left2,right2){
  if(as.numeric(left1-right2)*as.numeric(right1-left2) < 0){
    overlap = min(abs(left1-right2)+1, abs(right1-left2)+1,abs(left1-right1) + 1,abs(left2-right2) + 1)
 
    return(overlap)
  }
  else{
    return(0)
  }
}

for(i in 1:nrow(region)){
  subdat <- dat[dat[,1]==region[i,1] & dat[,4]==region[i,2],]
  if(nrow(subdat) == 1){
    GL1 = subdat[1,18]
    GR1 = subdat[1,19]
    HL1 = subdat[1,16]
    HR1 = subdat[1,17]
    GL2 = 0
    GR2 = 0
    HL2 = 0
    HR2 = 0
    ov <- rbind(ov,c(subdat[1,4],'Single_domain_protein',GR1-GL2,GL1,GR1,GL2,GR2,subdat[1,1],subdat[1,3],'Single_domain_pfam',HR1-HL2,HL1,HR1,HL2,HR2,abs(HL2-HR1)/subdat[1,3]))
  }
  if(nrow(subdat)>=2){
    subdat <- subdat[order(subdat[,18]),]
    for(j in 1:(nrow(subdat)-1)){
      for(k in (j+1)){
        GL1 = subdat[j,18]
        GR1 = subdat[j,19]
        GL2 = subdat[k,18]
        GR2 = subdat[k,19]
        HL1 = subdat[j,16]
        HR1 = subdat[j,17]
        HL2 = subdat[k,16]
        HR2 = subdat[k,17]
        if(Overlap(GL1,GR1,GL2,GR2)==0){ # regions on protein don't overlap
          if(Overlap(HL1,HR1,HL2,HR2)==0){ # regions on pfam domain don't overlap
            if(HR1 < HL2) ov <- rbind(ov,c(subdat[1,4],'Distance_protein',GR1-GL2,GL1,GR1,GL2,GR2,subdat[1,1],subdat[1,3],'Distance_pfam',HR1-HL2,HL1,HR1,HL2,HR2,abs(HL2-HR1)/subdat[1,3]))
            if(HR2 < HL1) ov <- rbind(ov,c(subdat[1,4],'Distance_protein',GR1-GL2,GL1,GR1,GL2,GR2,subdat[1,1],subdat[1,3],'Distance_pfam_but_reverse',HR2-HL1,HL1,HR1,HL2,HR2,abs(HL1-HR2)/subdat[1,3]))
          }
          if(Overlap(HL1,HR1,HL2,HR2)>0){ # regions on pfam domain overlap
            ov <- rbind(ov,c(subdat[1,4],'Distance_protein',GR1-GL2,GL1,GR1,GL2,GR2,subdat[1,1],subdat[1,3],'Overlapping_pfam',Overlap(HL1,HR1,HL2,HR2),HL1,HR1,HL2,HR2,Overlap(HL1,HR1,HL2,HR2)/subdat[1,3]))
          }
        }
        else{ # regions on protein overlap
          if(Overlap(HL1,HR1,HL2,HR2)==0){ # regions on pfam domain don't overlap
            if(HR1 < HL2) ov <- rbind(ov,c(subdat[1,4],'Overlapping_protein',Overlap(GL1,GR1,GL2,GR2),GL1,GR1,GL2,GR2,subdat[1,1],subdat[1,3],'Distance_pfam',HR1-HL2,HL1,HR1,HL2,HR2,abs(HL2-HR1)/subdat[1,3]))
            if(HR2 < HL1) ov <- rbind(ov,c(subdat[1,4],'Overlapping_protein',Overlap(GL1,GR1,GL2,GR2),GL1,GR1,GL2,GR2,subdat[1,1],subdat[1,3],'Distance_pfam_but_reverse',HR2-HL1,HL1,HR1,HL2,HR2,abs(HL1-HR2)/subdat[1,3]))
          }
          if(Overlap(HL1,HR1,HL2,HR2)>0){ # regions on pfam domain overlap
            ov <- rbind(ov,c(subdat[1,4],'Overlapping_protein',Overlap(GL1,GR1,GL2,GR2),GL1,GR1,GL2,GR2,subdat[1,1],subdat[1,3],'Overlapping_pfam',Overlap(HL1,HR1,HL2,HR2),HL1,HR1,HL2,HR2,Overlap(HL1,HR1,HL2,HR2)/subdat[1,3]))
          }
        }
      }
    }
  }
}


dim(ov)
head(ov)
ov <- cbind(ov, as.numeric(ov[,3])/as.numeric(ov[,9]))
colnames(ov) <- c("gene_ID", "P_overlap_type", "P_overlpping_length", "GL1","GR1","GL2","GR2", "Pfam_ID", "domain_size", "H_overlapping_type","H_overlapping_length", "HL1", "HR1", "HL2", "HR2", "H_propotion_overlap", "P_propotion_overlap")
head(ov)
#write.table(ov,"HMM_scan_modified_table_with_different_domain_combinations.txt",row.names=F,col.names=T,sep='\t',quote=F)
nrow(ov)

##subsetting according to the size of the domain
table(ov[,2], ov[,10])
tbl_2 <- unique(ov[,c(8,9)])
nrow(tbl_2)

tbl_150 <- ov[as.numeric(ov[,9])>=150,]
nrow(tbl_150)
table(tbl_150[,2], tbl_150[,10])
     
tbl_100 <- ov[as.numeric(ov[,9])>=100,]
nrow(tbl_100)
table(tbl_100[,2], tbl_100[,10])    

tbl_50 <- ov[as.numeric(ov[,9])>=50,]
nrow(tbl_50)
table(tbl_50[,2], tbl_50[,10])  

## Drawing digrams
new_metrix <- ov[ov[,2] == "Overlapping_protein" & ov[,10] == "Overlapping_pfam",]
new2 <- new_metrix[as.numeric(new_metrix[,9])>=150,]
pdf('Overlaping_P_vs_H.pdf', width = 10, height = 10)
par(mfrow=c(2,2))
plot(x = as.numeric(new_metrix[,3]), y= as.numeric(new_metrix[,11]),xlab='Overlapping length in protein',ylab='Overlapping length in Pfam')
plot(x = as.numeric(new_metrix[,17]), y= as.numeric(new_metrix[,16]),xlab='Overlapping length propotion in protein',ylab='Overlapping length propotion in Pfam')
plot(x = as.numeric(new2[,3]), y= as.numeric(new2[,11]),xlab='Overlapping length in protein',ylab='Overlapping length in Pfam')
plot(x = as.numeric(new2[,17]), y= as.numeric(new2[,16]),xlab='Overlapping length in protein',ylab='Overlapping length propotion in Pfam')
dev.off()