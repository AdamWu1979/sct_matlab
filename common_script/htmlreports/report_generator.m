classdef report_generator < handle
    %REPORT Summary of this class goes here
    %   Detailed explanation goes here
    %% Public Properites
    properties
        name;
        output_dir;
        report_dir;
        css_dir;
    end
    
    %% Private Properties
    properties (Access = private)
        wrote_header;
        wrote_footer;
        indent_level;
        figure_count;
        
    end
    
    %% Public Methods 
    methods
        
        % report(report_name, output_dir)
        % Constructor
        %
        function obj = report_generator(report_name, output_dir)
            obj.name = report_name;
            obj.wrote_header = 0;
            obj.wrote_footer = 0;
            obj.figure_count = 0;
            obj.indent_level = 1;
            obj.output_dir = output_dir;
            obj.initialize_directory();
        end
        
        % stylesheet(obj, stylesheet)
        % Set the report's stylesheet
        %
        function stylesheet(obj, stylesheet)
            copyfile(stylesheet, [obj.css_dir filesep 'style.css']);
        end
        
        % open(obj)
        % Open the report for writing
        %
        function open(obj)
            if ~obj.wrote_header
                obj.write_header();
                obj.wrote_header = 1;
            end
            obj.add_text(evalc('disp(datetime)'));
        end
        
        % stat = close(obj)
        % Close the report and return the status of the close operation
        %
        function close(obj)
            if ~obj.wrote_footer
                obj.write_footer();
            end
        end
        
        % add_text(text)
        % Adds text to the current section
        function add_text(obj, text)
            obj.print(sprintf('<div class="section_text">%s</div>\n', text));
            obj.filelink;
        end
        
        % new_section(sectionname)
        % Create a new section
        function section(obj, section_name)
            obj.print('<div class="section">\n');
            obj.nest
            obj.print(sprintf('<div class="section_title">%s</div>\n', section_name));
        end
        
        % new_subsection(subsectionname)
        % Create a new subsection
        function subsection(obj, subsection_name)
            obj.print('<div class="subsection">\n');
            obj.nest
            obj.print(sprintf('<div class="subsection_title">%s</div>\n', subsection_name));
        end
        
        % end_section()
        % close the current section or subsection
        function end_section(obj)
            obj.denest;
            obj.print('</div>\n');
        end
        
        % add_figure(h)
        % add the figure to the report
        % 
        function add_figure(obj,fig,caption,align)
            if ~exist('caption','var'), caption = ''; end
            if ~exist('align','var'), align = 'left'; end
            if isempty(fig), return; end
            while exist(fullfile(obj.report_dir,'img',sprintf('fig%d_%d.png', obj.figure_count,1)),'file')
                obj.figure_count = obj.figure_count+1;
            end
            for ff=1:length(fig)
                fname = sprintf('fig%d_%d.png', obj.figure_count,ff);
                figurepath = [obj.report_dir filesep 'img' filesep fname];
                saveas(fig(ff), figurepath);
            end
            obj.print(sprintf('<div class="img_container %s">\n', align));
            obj.nest;
            if length(fig)==1
                obj.print(sprintf('<img class="centered" src="img/%s">\n', fname));
            else
                obj.print(sprintf('<img src="img/%s" name="Image%d" width="615" height="457" usemap="#Map%d" id="Image%d">\n', fname,obj.figure_count,obj.figure_count,obj.figure_count));
                obj.print(sprintf('<map name="Map%d">\n', obj.figure_count));
                obj.nest;
                x=ceil(linspace(0,615,length(fig)+1));
                for ff=1:length(fig)
                    obj.print(sprintf('<area shape="rect" coords="%d,0,%d,%d" href="#" onMouseOver="MM_swapImage(''Image%d'','''',''img/fig%d_%d.png'',1)">\n', x(ff),x(ff+1),457,obj.figure_count,obj.figure_count,ff));
                end
                obj.denest;
                obj.print(sprintf('</map>\n'));
            end
            obj.print(sprintf('<div class="caption centered">%s</div>\n', caption));
            obj.denest;
            obj.print('</div>');
            obj.figure_count = obj.figure_count + 1;
            
            obj.filelink;
        end
        
        function add_table(obj,varargin)
            HTML = GTHTMLtable(varargin{:});
            obj.print(HTML);
            obj.filelink;
        end
        
    end
    
    %% Private Mehtods
    methods(Access = private)
        
        % Set up output directory structure
        %
        %
        function initialize_directory(obj)    
            % Create the output directory if we need to
            if ~exist(obj.output_dir,'dir')
                mkdir(obj.output_dir);
            end
            % Setup the report directory
            obj.report_dir = [obj.output_dir filesep obj.name];
            obj.css_dir = [obj.report_dir filesep 'css'];
            img_dir = [obj.report_dir filesep 'img'];
            % Create report subfolders
            if ~exist(obj.report_dir,'dir')
                mkdir(obj.report_dir);
            end
            if ~exist(obj.css_dir,'dir')
                mkdir(obj.css_dir);
            end
            if ~exist(img_dir,'dir')
                mkdir(img_dir);
            end
            obj.stylesheet(fullfile(fileparts(which(mfilename)),'res/css/default.css'))
        end
        
        
        % Write HTML header to output file
        %
        %
        function write_header(obj)
            obj.print('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">\n');
            obj.print('<html>\n');
            obj.nest;
            obj.print('<head>\n');
            obj.nest;
            obj.print(sprintf('<title>%s</title>\n',obj.name));
            obj.print('<link rel="stylesheet" type="text/css" href="css/style.css">');
            obj.denest;
            obj.print('</head>\n');
            
            obj.print('<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">\n');
            obj.print('<script language="JavaScript" type="text/JavaScript">\n');
            obj.nest;
            obj.print('function MM_swapImgRestore() { //v3.0\n');
            obj.print('  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;\n');
            obj.print('}\n\n');
            obj.print('function MM_findObj(n, d) { //v4.01\n');
            obj.print('  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {\n');
            obj.print('    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}\n');
            obj.print('  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];\n');
            obj.print('  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);\n');
            obj.print('  if(!x && d.getElementById) x=d.getElementById(n); return x;\n');
            obj.print('}\n\n');
            obj.print('function MM_swapImage() { //v3.0\n');
            obj.print('  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)\n');
            obj.print('   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}\n');
            obj.print('}\n');
            obj.denest;
            obj.print('</script>\n');
            obj.print('<body>\n');
            obj.nest;
        end
        
        
        % Write HTML Footer to output file
        %
        function write_footer(obj)
            obj.denest;
            obj.print('</body>\n');
            obj.denest;
            obj.print('</html>\n');
        end
        
        % Indent text to the current nesting level
        %
        function str = indent(obj,string)
            if obj.indent_level > 1
                for i = 2:obj.indent_level
                    string = sprintf('\t%s', string);
                end
            end
            str = string;
        end
        
        % Increse current nesting level
        %
        function nest(obj)
            obj.indent_level = obj.indent_level + 1;
        end
        
        % Decrease current nesting level
        %
        function denest(obj)
            obj.indent_level = obj.indent_level - 1;
        end
        
        function filelink(obj)
            fprintf('saved to HTML file <a href="%s">%s</a>',[obj.report_dir filesep 'index.html'],[obj.report_dir filesep 'index.html']);
        end
        
        %% Write text to htmlfile
        function print(obj, text)
            fid = fopen([obj.report_dir filesep 'index.html'], 'a+');
            fprintf(fid, obj.indent(text));
            fclose(fid);
            
        end
    end
    
end

