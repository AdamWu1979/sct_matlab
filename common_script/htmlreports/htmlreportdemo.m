% HTMLREPORTDEMO
% Generates a demo report in the Output directory of this module
%
%
clear
r = report_generator('Test Report', pwd);
r.open();
r.section('A Demo Report');
r.add_text('This is an example HTML report generated from Matlab. Discuss what you did here, maybe give a few example calculations:');
r.add_text(sprintf('exp(-2*pi*0.5) = %f', exp(-2*pi*0.5)));
r.subsection('Figures')
logo; h(1) = gcf;
r.add_text('This is a subsection demonstrating how figures/plots can be added directly to the report');
r.add_figure(gcf,'You can add figures to the report directly','left');
logo; camorbit(20,0); h(2) = gcf;
r.add_figure(gcf,'And align them however you want', 'centered');
r.add_text('This is a subsection demonstrating how multiple figures can be displayed interactively to the report');
r.add_figure(h,'interactive - move your mouse over to switch between figures','left');
r.end_section(); 
r.end_section(); 
r.close();