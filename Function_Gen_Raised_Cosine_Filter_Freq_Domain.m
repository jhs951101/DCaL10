function [Hf, freq] = Function_Gen_Raised_Cosine_Filter_Freq_Domain(Rb, df, roll_off)

Tb = 1/Rb;

freq = -5*Rb:df:5*Rb;

Hf = zeros(1, length(freq));

Hf(freq <= (1-roll_off)/(2*Tb) & freq >= -(1-roll_off)/(2*Tb)) = Tb;

Hf(freq > (1-roll_off)/(2*Tb) & freq <= (1+roll_off)/(2*Tb)) = (Tb/2)*( 1 + cos( ((pi*Tb)/roll_off).*(freq(freq > (1-roll_off)/(2*Tb) & freq <= (1+roll_off)/(2*Tb)) - (1-roll_off)/(2*Tb))));
Hf(freq < -(1-roll_off)/(2*Tb) & freq >= -(1+roll_off)/(2*Tb)) = (Tb/2)*( 1 + cos( ((pi*Tb)/roll_off).*(-freq(freq < -(1-roll_off)/(2*Tb) & freq >= -(1+roll_off)/(2*Tb)) - (1-roll_off)/(2*Tb))));