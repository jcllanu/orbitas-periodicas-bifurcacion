
function sliderApp2
str=['Ajusta el valor de ',char(955), ' en el sistema'];
fig = uifigure("Position",[150 400 500 400],'Name',str);
g = uigridlayout(fig);
g.RowHeight = {'1x','fit','1x'};
g.ColumnWidth = {'1x','fit'};
textAnnotation = annotation(g, 'textbox', [0.5 0.6 0.2 0.2], 'String', '$x'' = \lambda x + y +[c^2-(x^2+y^2-c)^2]x \\y'' = -x + \lambda y +[c^2-(x^2+y^2-c)^2]y$', 'Interpreter', 'latex', 'FontSize', 16, 'HorizontalAlignment', 'center');
textAnnotation.EdgeColor = 'none';
sld = uislider(g, "ValueChangingFcn",@(src,event)updateGauge(src,event,fig));
sld.Limits = [-2 1];
sld.Value = 0;
sld.Layout.Row = 2;
sld.Layout.Column = 1;
c=1;
sld.MajorTicks = [-2*c^2 -c^2 0 c^2];
end

function updateGauge(src,event,fig)
    c=1;
    lambda=event.Value;
    if abs(lambda+c^2)<0.03
        lambda=-1;
    end
    if abs(lambda)<0.03
        lambda=0;
    end
    f= @(t,x)[lambda*x(1)+x(2)+(c*c-(x(1)^2+x(2)^2-c)^2)*x(1);-x(1)+lambda*x(2)+(c*c-(x(1)^2+x(2)^2-c)^2)*x(2)];
    intervalo=[0,100];
    N=1000;
    figura=figure(1);
    figura.Position = [700, 150, 1150, 675];
    subplot(2,3,[2 3 5 6])
    brown=[171 104 87]./255;
    plot([0 0], [-4 4],'k');  %axis
    hold on
    plot([-4 4], [0 0],'k');  
    if lambda<-c^2
        %There are not periodic orbits      
        % Solution with r_0=sqrt(c)
        x0=[sqrt(c),0];
        [~,x]=ode45(f,intervalo,x0,N);
        h1=plot(x(:,1),x(:,2),'m');        
        hold on         
        scatter(x0(1),x0(2),'m')
        % Equilibrium point as. stable
        h2=scatter(0,0,'g','filled');
        legend([h2 h1],'Punto de equilibrio as. estable',strcat(strcat('Solución con dato inicial (',sprintf('%0.2f',sqrt(c)),',0)')))
    elseif lambda==-c^2
        % Solution with r_0=sqrt(c)+0.5
        x0=[sqrt(c)+0.5,0];
        [~,x]=ode45(f,intervalo,x0,N);
        h3=plot(x(:,1),x(:,2),'c');
        hold on 
        scatter(x0(1),x0(2),'c');
        % Solution with r_0=2*sqrt(c)/3
        x0=[2*sqrt(c)/3,0];
        [~,x]=ode45(f,intervalo,x0,N);
        h4=plot(x(:,1),x(:,2),'Color',brown);
        scatter(x0(1),x0(2),'Color',brown);
        %There is an unstable periodic orbit with r_0=sqrt(c).
        r_0=sqrt(c);
        x=r_0*cos(0:1/N:2*pi);
        y=r_0*sin(0:1/N:2*pi);
        h2=plot(x,y,'r--');
        % Equilibrium point as. stable
        h1=scatter(0,0,'g','filled'); 
        legend([h1 h2 h3 h4],'Punto de equilibrio as. estable',strcat('Órbita periódica inestable de radio ',sprintf('%0.2f',sqrt(c))), ...
            strcat(strcat('Solución con dato inicial (',sprintf('%0.2f',sqrt(c)+0.5),',0)')), ...
            strcat(strcat('Solución con dato inicial (',sprintf('%0.2f',2*sqrt(c)/3),',0)')));
    elseif lambda>-c^2 && lambda<0
        %There are two periodic orbits.
        r_1=sqrt(c+sqrt(lambda+c^2));
        r_2=sqrt(c-sqrt(lambda+c^2));
        % Solution with r_0=r_1+0.5
        x0=[r_1+0.5,0];
        [~,x]=ode45(f,intervalo,x0,N);
        h4=plot(x(:,1),x(:,2),'c');
        hold on 
        scatter(x0(1),x0(2),'c');
        % Solution with r_0=sqrt(c)
        x0=[sqrt(c),0];
        [~,x]=ode45(f,intervalo,x0,N);
        h5=plot(x(:,1),x(:,2),'m');
        scatter(x0(1),x0(2),'m')
        % Solution with r_0=2*r_2/3
        x0=[2*r_2/3,0];
        [~,x]=ode45(f,intervalo,x0,N);
        h6=plot(x(:,1),x(:,2),'Color',brown);
        scatter(x0(1),x0(2),'Color',brown);
        %The orb. as. stable has period r_1=sqrt(c+sqrt(lambda+c^2))
        x=r_1*cos(0:1/N:2*pi);
        y=r_1*sin(0:1/N:2*pi);
        h2=plot(x,y,'g');
        %The unstable has period r_2=sqrt(c-sqrt(lambda+c^2))
        x=r_2*cos(0:1/N:2*pi);
        y=r_2*sin(0:1/N:2*pi);
        h3=plot(x,y,'r--');
        % Equilibrium point as. stable
        h1=scatter(0,0,'g','filled');

        legend([h1 h2 h3 h4 h5 h6],'Punto de equilibrio as. estable',strcat('Órbita periódica orb. as. estable de radio ',sprintf('%0.2f',r_1)), ...
            strcat('Órbita periódica inestable de radio ',sprintf('%0.2f',r_2)),...
            strcat(strcat('Solución con dato inicial (',sprintf('%0.2f',r_1+0.5),',0)')), ...
            strcat(strcat('Solución con dato inicial (',sprintf('%0.2f',sqrt(c)),',0)')), ...
            strcat(strcat('Solución con dato inicial (',sprintf('%0.2f',2*r_2/3),',0)')));
    elseif  lambda>=0
        r_1=sqrt(c+sqrt(lambda+c^2));
         % Solution with r_0=r_1+0.5
        x0=[r_1+0.5,0];
        [~,x]=ode45(f,intervalo,x0,N);
        h3=plot(x(:,1),x(:,2),'c');
        hold on 
        scatter(x0(1),x0(2),'c');
        % Solution with r_0=sqrt(c)
        x0=[sqrt(c),0];
        [~,x]=ode45(f,intervalo,x0,N);
         h4=plot(x(:,1),x(:,2),'m');
        scatter(x0(1),x0(2),'m')
        x0=[0.1,0];
        [~,x]=ode45(f,intervalo,x0,N);
         h5=plot(x(:,1),x(:,2),'Color',brown);
        scatter(x0(1),x0(2),'Color',brown)
        %There is an orb. as. stable period orbit whose period is r_1=sqrt(c+sqrt(lambda+c^2))
        x=r_1*cos(0:1/N:2*pi);
        y=r_1*sin(0:1/N:2*pi);
        h2=plot(x,y,'g');        
        % Equilibrium point unstable
        h1=scatter(0,0,'r','filled');

        legend([h1 h2 h3 h4 h5],'Punto de equilibrio inestable',strcat('Órbita periódica orb. as. estable de radio ',sprintf('%0.2f',r_1)), ...
            strcat(strcat('Solución con dato inicial (',sprintf('%0.2f',r_1+0.5),',0)')), ...
            strcat(strcat('Solución con dato inicial (',sprintf('%0.2f',sqrt(c)),',0)')), ...
            strcat('Solución con dato inicial (0.10,0)'));
    end
    xlim([-2 2])
    ylim([-2 2])
    title('Diagrama de fases')
    subtitle(strcat('\lambda=',sprintf('%0.2f',lambda)));
    hold off
    axis equal

    subplot(2,3,1)    
    plot([0 0], [-4 4],'k');  %x-axis
    hold on
    plot([-4 4], [0 0],'k');  %y-axis
    plot([-4 4],[1 1],'r');  
    plot([-4 4],[-1 -1],'r');
    h1=scatter(lambda,1,'c','filled');
    h2=scatter(lambda,-1,'g','filled');
    title('Autovalores \sigma_1(\lambda) y \sigma_2(\lambda) de la linealización del sistema')
    subtitle(strcat('\lambda=',sprintf('%0.2f',lambda)));
    legend([h1 h2],strcat('\sigma_1(\lambda)=',sprintf('%0.2f+i',lambda)),strcat('\sigma_2(\lambda)=',sprintf('%0.2f-i',lambda)))
    xlim([-3 3])
    ylim([-3 3])
    hold off
    axis equal

    ax=subplot(2,3,4);
    xlim(ax,[-3 2])
    ylim(ax,[0 2])    
    
    g=@(x) (x.^2-c).^2-c.^2;
    x1=0:0.01:1;
    x2=1:0.01:1.55;
    y1=g(x1);
    y2=g(x2);
    plot(y1,x1,'r--');
    hold on
    plot(y2,x2,'g');
    plot([-2 0],[0 0],'g');
    plot([0 1],[0 0],'r--');
    scatter(0,0,'r');
    scatter(-1,1,'r');
    scatter(lambda,0,'k','filled');
    if lambda>-c^2
        scatter(lambda,sqrt(c+sqrt(lambda+c^2)),'k','filled');
    end
    if lambda>=-c^2 &&  lambda<0
        scatter(lambda,sqrt(c-sqrt(lambda+c^2)),'k','filled');
    end
    title(ax,'Diagrama de bifurcación')
    subtitle(ax,strcat('\lambda=',sprintf('%0.2f',lambda)));
    axis equal
    hold off
end