function print_experiment(fid, experiment)

fprintf(fid,'  <experiment name="%s" repetitions="10" runMetricsEveryStep="true">\n',experiment.name);
fprintf(fid,'    <setup>random-seed new-seed\n');
fprintf(fid,'setup</setup>\n');
fprintf(fid,'    <go>go</go>\n');
fprintf(fid,'    <timeLimit steps="%d"/>\n',experiment.simulation_length);
% fprintf(fid,'    <metric>count objects with [kind = "Cell"]</metric>\n');
% fprintf(fid,'    <metric>count objects with [my-fate = "Necrosis"]</metric>\n');
for i=1:length(experiment.reporters)
    fprintf(fid,'    <metric>%s</metric>\n',experiment.reporters{i});
end
% fprintf(fid, '    <metric>[table:get substances-of-patch "EGF"] of patch 0 0 0</metric>\n');
fprintf(fid,'    <enumeratedValueSet variable="the-diffusion-parameters-file">\n');
fprintf(fid,'      <value value="&quot;%s&quot;"/>\n',experiment.the_diffusion_parameters_file);
fprintf(fid,'    </enumeratedValueSet>\n');
fprintf(fid,'    <enumeratedValueSet variable="the-intercellular-step">\n');
fprintf(fid,'      <value value="100"/>\n');
fprintf(fid,'    </enumeratedValueSet>\n');
fprintf(fid,'    <enumeratedValueSet variable="the-input-parameters-file">\n');
fprintf(fid,'      <value value="&quot;%s&quot;"/>\n',experiment.the_input_parameters_file);
fprintf(fid,'    </enumeratedValueSet>\n');
fprintf(fid,'    <enumeratedValueSet variable="the-intracellular-step">\n');
fprintf(fid,'      <value value="1"/>\n');
fprintf(fid,'    </enumeratedValueSet>\n');
fprintf(fid,'    <enumeratedValueSet variable="the-cell-size">\n');
fprintf(fid,'      <value value="100"/>\n');
fprintf(fid,'    </enumeratedValueSet>\n');
fprintf(fid,'    <enumeratedValueSet variable="the-maximum-cell-count">\n');
fprintf(fid,'      <value value="4000"/>\n');
fprintf(fid,'    </enumeratedValueSet>\n');
fprintf(fid,'    <enumeratedValueSet variable="the-associations-file">\n');
fprintf(fid,'      <value value="&quot;%s&quot;"/>\n',experiment.the_associations_file);
fprintf(fid,'    </enumeratedValueSet>\n');
fprintf(fid,'    <enumeratedValueSet variable="the-initial-cell-count">\n');
fprintf(fid,'      <value value="%d"/>\n',experiment.initial_cell_count);
fprintf(fid,'    </enumeratedValueSet>\n');
fprintf(fid,'    <enumeratedValueSet variable="the-diffusion-step">\n');
fprintf(fid,'      <value value="1"/>\n');
fprintf(fid,'    </enumeratedValueSet>\n');
fprintf(fid,'    <enumeratedValueSet variable="the-sparse-grid">\n');
fprintf(fid,'      <value value="1"/>\n');
fprintf(fid,'    </enumeratedValueSet>\n');
fprintf(fid,'    <enumeratedValueSet variable="the-file-of-mutations">\n');
fprintf(fid,'      <value value="&quot;%s&quot;"/>\n',experiment.the_file_of_mutations);
fprintf(fid,'    </enumeratedValueSet>\n');
fprintf(fid,'    <enumeratedValueSet variable="the-batch-mode?">\n');
fprintf(fid,'      <value value="false"/>\n');
fprintf(fid,'    </enumeratedValueSet>\n');
fprintf(fid,'    <enumeratedValueSet variable="the-reversible?">\n');
fprintf(fid,'      <value value="true"/>\n');
fprintf(fid,'    </enumeratedValueSet>\n');
fprintf(fid,'  </experiment>\n');
fprintf(fid,'\n');

