function savefig(file,width,height)


ax = gca;

ax.XTickMode = 'manual'; ax.YTickMode = 'manual'; ax.ZTickMode = 'manual';
ax.XLimMode = 'manual'; ax.YLimMode = 'manual'; ax.ZLimMode = 'manual';

fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 width height];
print(file,'-dtiff','-r600');