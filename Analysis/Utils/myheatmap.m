function h = myheatmap(s)



h = imagesc(s.data);

% axis off;

set(gca,'XTick',1:size(s.data,2),'XTickLabel',s.xlabel,'XTickLabelRotation',90);
set(gca,'YTick',1:size(s.data,1),'YTickLabel',s.ylabel);

ax = axis;

hold on;
% vertical lines
for i=ax(1):ax(2);plot([i,i],[ax(3),ax(4)],'Color',[0.85 0.85 0.85 0.85]); end; % [0.15 0.15 0.15 0.1]
% horizontal lines
for i=ax(3):ax(4);plot([ax(1),ax(2)],[i,i],'Color',[0.85 0.85 0.85 0.85]); end;


plot([ax(1) ax(1)],[ax(3) ax(4)],'k')
plot([ax(2) ax(2)],[ax(3) ax(4)],'k')
plot([ax(1) ax(2)],[ax(3) ax(3)],'k')
plot([ax(1) ax(2)],[ax(4) ax(4)],'k')

hold off;