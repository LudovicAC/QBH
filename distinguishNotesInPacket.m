function [packets] = distinguishNotesInPacket(packet)
    packets = [];
    %q = 0.2; %arbitraire
    %seuil = quantile(packet, q)
    seuil = median(packet)/2;
    
    packet(packet < seuil) = 0;
    packets = delimit_packets(packet);
end