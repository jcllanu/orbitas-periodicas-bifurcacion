
function sliderApp2
str=['Ajusta el valor de ',char(955), ' en el sistema'];
fig = uifigure("Position",[75 300 500 400],'Name',str);
g = uigridlayout(fig);
g.RowHeight = {'1x','fit','1x'};
g.ColumnWidth = {'1x','fit'};
textAnnotation = annotation(g, 'textbox', [0.5 0.6 0.2 0.2], 'String', '$z'''' -(\lambda-z^2)z'' +z = 0 \iff \\\left\{ \begin{array}{ll} x''=y\\ y''= -x+(\lambda- x^2) y \end{array} \right. $', 'Interpreter', 'latex', 'FontSize', 16, 'HorizontalAlignment', 'center');
textAnnotation.EdgeColor = 'none';
sld = uislider(g, "ValueChangingFcn",@(src,event)updateGauge(src,event,fig));
sld.Limits = [-2.5 2.5];
sld.Value = 0;
sld.Layout.Row = 2;
sld.Layout.Column = 1;
sld.MajorTicks = [-2.5 -2 -1.5 -1 -0.5 0 0.5 1 1.5 2 2.5];
end

function updateGauge(src,event,fig)
    lambda=event.Value;
    if -0.03<lambda && lambda<0
        lambda=0;
    end
    f= @(t,x)[x(2);-x(1)+(lambda-x(1)*x(1))*x(2)];
    intervalo=[0,200];
    N=1000;
    figura=figure(1);
    figura.Position = [600, 150, 1250, 625];
    subplot(2,3,[2 3 5 6])
    brown=[171 104 87]./255;
    plot([0 0], [-5 5],'k');  %x-axis
    hold on
    plot([-5 5], [0 0],'k');  %y-axis

    if(lambda>0)
        [~,x]=ode45(f,intervalo,[2.5,0]);
        h3=plot(x(:,1),x(:,2),'c');        
        hold on 
        scatter(2.5,0,'c')
    else
        [~,x]=ode45(f,intervalo,[1.5,0]);
        h3=plot(x(:,1),x(:,2),'c');        
        hold on 
        scatter(1.5,0,'c')
    end
    

    [~,x]=ode45(f,intervalo,[1,0]);
    h2=plot(x(:,1),x(:,2),'m');        
    hold on 
    scatter(1,0,'m')

    [~,x]=ode45(f,intervalo,[0.1,0]);
    h4=plot(x(:,1),x(:,2),'b');        
    hold on 
    scatter(0.1,0,'b')
    if lambda<=0      
        % Equilibrium point as. stable
        h1=scatter(0,0,'g','filled');
        legend([h1 h2 h3 h4],'Punto de equilibrio as. estable','Solución con dato inicial (1.5, 0)','Solución con dato inicial (1, 0)','Solución con dato inicial (0.1, 0)')
    else
        [~,x]=ode45(f,intervalo,[2,0]);
        n=size(x,1);
        h5=plot(x(round(9*n/10):n,1),x(round(9*n/10):n,2),'g','LineWidth',3);        
        hold on 
        h1=scatter(0,0,'r','filled');
        h6=scatter(sqrt(4*lambda),0,'k','filled');
        legend([h1 h2 h3 h4 h5 h6],'Punto de equilibrio inestable','Solución con dato inicial (2.5, 0)','Solución con dato inicial (1, 0)','Solución con dato inicial (0.1, 0)','Orb. periódica asint. estable','(2\surd\lambda, 0)')
    end
    xlim([-4 4])
    ylim([-4 4])
    title('Diagrama de fases')
    subtitle(strcat('\lambda=',sprintf('%0.4f',lambda)));
    hold off
    axis equal

    subplot(2,3,1)    
    plot([0 0], [-5 5],'k');  %x-axis
    hold on
    plot([-5 5], [0 0],'k');  %y-axis
    plot([-5 5],[0 0],'r');
    plot(cos(0:0.01:7),sin(0:0.01:7),'r')
    title('Autovalores \sigma_1(\lambda) y \sigma_2(\lambda) de la linealización del sistema en el plano complejo')
    subtitle(strcat('\lambda=',sprintf('%0.2f',lambda)));
    if lambda^2<4
        h1=scatter(lambda/2,sqrt(4-lambda^2)/2,'c','filled');
        h2=scatter(lambda/2,-sqrt(4-lambda^2)/2,'g','filled');
        legend([h1 h2],strcat('\sigma_1(\lambda)=',sprintf('%0.2f + %0.2fi',lambda/2,sqrt(4-lambda^2)/2)),strcat('\sigma_2(\lambda)=',sprintf('%0.2f-%0.2fi',lambda/2,sqrt(4-lambda^2)/2)))
    else
        h1=scatter(lambda/2+sqrt(lambda^2-4)/2,0,'c','filled');
        h2=scatter(lambda/2-sqrt(lambda^2-4)/2,0,'g','filled');
        legend([h1 h2],strcat('\sigma_1(\lambda)=',sprintf('%0.2f',lambda/2+sqrt(lambda^2-4)/2)),strcat('\sigma_2(\lambda)=',sprintf('%0.2f',lambda/2-sqrt(lambda^2-4)/2)))
    end
    xlim([-3 3])
    ylim([-3 3])
    hold off
    axis equal

    subplot(2,3,4); 
    g=@(x) 2*sqrt(x);
    x1=0:0.01:2.5;
    y1=g(x1);
    plot(x1,y1,'g');
    hold on
    plot([-2.5 0],[0 0],'g');
    plot([0 2.5],[0 0],'r--');
    scatter(0,0,'g');    
    if lambda>0
        h2=scatter(lambda,0,'r','filled');
        h1=scatter(lambda,g(lambda),'g','filled');
        legend([h1 h2],'Órbita periódica as. estable de ''radio'' 2\surd\lambda', 'Punto de equilibrio inestable')
    else
        h2=scatter(lambda,0,'g','filled');
        legend(h2, 'Punto de equilibrio as. estable');
    end    
    title('Diagrama de bifurcación')
    subtitle(strcat('\lambda=',sprintf('%0.2f',lambda)));
    xlim([-2.5 2.5])
    ylim([0 3.75])
    hold off
end