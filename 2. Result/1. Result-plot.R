library(ggplot2)
library(dplyr)
library(readxl)
library(tidyr)
library(tidyverse)
# deposit  ----------------------------------------------------------------------------

dt <- read_xlsx("/Users/xingchenchen/Library/CloudStorage/Box-Box/BA952- Finance II/Data/Data Processed/3. results.xlsx", sheet = 1)

dt <- dt %>% mutate(upper = estimate + 1.96 * std.error,
                    lower = estimate - 1.96 * std.error)
dt <- dt %>% mutate(upper_2 = estimate + 1.645 * std.error,
                    lower_2 = estimate - 1.645 * std.error)

dt <- dt %>% filter(term != "prcp")
dt <- dt %>%
  separate(term, into = c("bins", "risktype"), sep = "_")

dt$bins <- factor(dt$bins, levels = c("dd5binBelow3", "dd5bin3", "dd5bin8", "dd5bin23", "dd5bin28", "dd5bin33up"), 
                  labels = c("<3ºC","3~8ºC","8~13ºC","23~28ºC","28~33ºC",">33ºC"))

theme_update(
  legend.title      = element_text(colour = "black",size = 10),
  legend.text= element_text(size = 10),
  legend.key        = element_blank(),
  legend.background = element_blank(),
  legend.position   = c(0.25, 0.8),
  axis.text         = element_text(colour = "black"),
  #panel.grid.major  = element_blank(),
  #panel.grid.minor  = element_blank(),
  panel.background  = element_blank(),  
  panel.border      = element_rect(fill = "transparent", colour="black",linewidth = 0.2),
  strip.background = element_rect(fill = NA, color = "black", size = 0.2),
  strip.text = element_text(colour = "black",size = 10)
)

coef_plot <- ggplot(data = dt, aes(x = bins, y = estimate, color = risktype)) +
  geom_linerange(aes(ymin = lower, ymax = upper),  
                 alpha = 0.5, size = 1,position = position_dodge(width = 0.4)) +
  geom_linerange(aes(ymin = lower_2, ymax = upper_2), 
                 alpha = 0.8, size = 2,position = position_dodge(width = 0.4)) +
  geom_point(aes(shape = risktype), size = 1.5, color = "black",position = position_dodge(width = 0.4))+
  ylab("(+ Percentage Change) Deposit Amount") +
  xlab("Weather Variable") +
  theme(legend.position = c(0.2,0.8)) +
  geom_hline(yintercept = 0, linetype = "dotted")

print(coef_plot)

ggsave("2. Changing in Deposit Amount.pdf", coef_plot, width = 180, height = 100, units = "mm", dpi = 300)

# loan amount  ----------------------------------------------------------------------------

dt <- read_xlsx("/Users/xingchenchen/Library/CloudStorage/Box-Box/BA952- Finance II/Data/Data Processed/results.xlsx", sheet = 2)
dt$grid <- "# of Small Farm Loan"
dt1 <- read_xlsx("/Users/xingchenchen/Library/CloudStorage/Box-Box/BA952- Finance II/Data/Data Processed/results.xlsx", sheet = 3)
dt1$grid <- "# of Small Business Loan"
dt <- rbind(dt, dt1)
dt1 <- read_xlsx("/Users/xingchenchen/Library/CloudStorage/Box-Box/BA952- Finance II/Data/Data Processed/results.xlsx", sheet = 4)
dt1$grid <- "Amt of Small Farm Loan"
dt <- rbind(dt, dt1)
dt1 <- read_xlsx("/Users/xingchenchen/Library/CloudStorage/Box-Box/BA952- Finance II/Data/Data Processed/results.xlsx", sheet = 5)
dt1$grid <- "Amt of Small Business Loan"
dt <- rbind(dt, dt1)
dt <- dt %>% mutate(upper = estimate + 1.96 * std.error,
                    lower = estimate - 1.96 * std.error)
dt <- dt %>% mutate(upper_2 = estimate + 1.645 * std.error,
                    lower_2 = estimate - 1.645 * std.error)

dt <- dt %>% filter(term != "prcp")
dt <- dt %>%
  separate(term, into = c("bins", "risktype"), sep = "_")

dt$bins <- factor(dt$bins, levels = c("dd5binBelow3", "dd5bin3", "dd5bin8", "dd5bin23", "dd5bin28", "dd5bin33up"), 
                  labels = c("<3ºC","3~8ºC","8~13ºC","23~28ºC","28~33ºC",">33ºC"))

coef_plot <- ggplot(data = dt, aes(x = bins, y = estimate, color = risktype)) +
  geom_linerange(aes(ymin = lower, ymax = upper),  
                 alpha = 0.5, size = 1,position = position_dodge(width = 0.4)) +
  geom_linerange(aes(ymin = lower_2, ymax = upper_2), 
                 alpha = 0.8, size = 2,position = position_dodge(width = 0.4)) +
  geom_point(aes(shape = risktype), size = 1.5, color = "black",position = position_dodge(width = 0.4))+
  ylab("(+ Percentage Change) Loan Amount") +
  xlab("Weather Variable") +
  theme(legend.position = c(0.9,0.9)) +
  facet_wrap(~grid) +
  geom_hline(yintercept = 0, linetype = "dotted")

print(coef_plot)

ggsave("2. Changing in Loan Amount.pdf", coef_plot, width = 180, height = 100, units = "mm", dpi = 300)

# loan quality  ----------------------------------------------------------------------------

dt <- read_xlsx("/Users/xingchenchen/Library/CloudStorage/Box-Box/BA952- Finance II/Data/Data Processed/results.xlsx", sheet = 6)
dt$grid <- "Overall Pastdue Amount of Ag Loan"
dt$loantype <- "Ag Loan"
dt$defaulttype <- "Over 30 days"
dt1 <- read_xlsx("/Users/xingchenchen/Library/CloudStorage/Box-Box/BA952- Finance II/Data/Data Processed/results.xlsx", sheet = 7)
dt1$grid <- "Overall Pastdue Amount of C & I Loan"
dt1$loantype <- "C & I Loan"
dt1$defaulttype <- "Over 30 days"

dt2 <- read_xlsx("/Users/xingchenchen/Library/CloudStorage/Box-Box/BA952- Finance II/Data/Data Processed/results.xlsx", sheet = 8)
dt2$grid <- "Pastdue 30 to 89 of Ag Loan"
dt2$loantype <- "Ag Loan"
dt2$defaulttype <- "30 to 89 days"
dt3 <- read_xlsx("/Users/xingchenchen/Library/CloudStorage/Box-Box/BA952- Finance II/Data/Data Processed/results.xlsx", sheet = 9)
dt3$grid <- "Pastdue 30 to 89 of C & I Loan"
dt3$loantype <- "C & I Loan"
dt3$defaulttype <- "30 to 89 days"

dt4 <- read_xlsx("/Users/xingchenchen/Library/CloudStorage/Box-Box/BA952- Finance II/Data/Data Processed/results.xlsx", sheet = 10)
dt4$grid <- "Pastdue Over 90 of Ag Loan"
dt4$defaulttype <- "Over 90 days"
dt4$loantype <- "Ag Loan"
dt5 <- read_xlsx("/Users/xingchenchen/Library/CloudStorage/Box-Box/BA952- Finance II/Data/Data Processed/results.xlsx", sheet = 11)
dt5$grid <- "Pastdue Over 90 of C & I Loan"
dt5$loantype <- "C & I Loan"
dt5$defaulttype <- "Over 90 days"

dt <- rbind(dt, dt1)
dt <- rbind(dt, dt2)
dt <- rbind(dt, dt3)
dt <- rbind(dt, dt4)
dt <- rbind(dt, dt5)

dt <- dt %>% mutate(upper = estimate + 1.96 * std.error,
                    lower = estimate - 1.96 * std.error)
dt <- dt %>% mutate(upper_2 = estimate + 1.645 * std.error,
                    lower_2 = estimate - 1.645 * std.error)

dt <- dt %>% filter(term != "prcp")
dt <- dt %>%
  separate(term, into = c("bins", "risktype"), sep = "_")


dt$bins <- factor(dt$bins, levels = c("dd5binBelow3", "dd5bin3", "dd5bin8", "dd5bin23", "dd5bin28", "dd5bin33up"), 
                  labels = c("<3ºC","3~8ºC","8~13ºC","23~28ºC","28~33ºC",">33ºC"))

dt$defaulttype <- factor(dt$defaulttype, levels = c("Over 30 days", "30 to 89 days", "Over 90 days"))

coef_plot <- ggplot(data = dt, aes(x = bins, y = estimate, color = risktype)) +
  geom_linerange(aes(ymin = lower, ymax = upper),  
                 alpha = 0.5, size = 1,position = position_dodge(width = 0.4)) +
  geom_linerange(aes(ymin = lower_2, ymax = upper_2), 
                 alpha = 0.8, size = 2,position = position_dodge(width = 0.4)) +
  geom_point(aes(shape = risktype), size = 1.5, color = "black",position = position_dodge(width = 0.4))+
  ylab("(+ Percentage Change) Pastdue Amount") +
  xlab("Weather Variable") +
  theme(legend.position = c(0.8,0.8)) +
  facet_grid(loantype~defaulttype, scales = "free_y") +
  geom_hline(yintercept = 0, linetype = "dotted")

print(coef_plot)

ggsave("2. Changing in Loan Quality.pdf", coef_plot, width = 300, height = 160, units = "mm", dpi = 300)



