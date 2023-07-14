
function sliderApp3
str=['Ajusta el valor de ',char(955), ' en la ecuación'];
fig = uifigure("Position",[250 400 500 400],'Name',str);
g = uigridlayout(fig);
g.RowHeight = {'1x','fit','1x'};
g.ColumnWidth = {'1x','fit'};
textAnnotation = annotation(g, 'textbox', [0.5 0.6 0.2 0.2], 'String', '$x''''+\lambda x''+ x=0 $', 'Interpreter', 'latex', 'FontSize', 16, 'HorizontalAlignment', 'center');
textAnnotation.EdgeColor = 'none';
sld = uislider(g, "ValueChangingFcn",@(src,event)updateGauge(src,event,fig));
sld.Limits = [-1 1];
sld.Value = 0;
sld.Layout.Row = 2;
sld.Layout.Column = 1;
sld.MajorTicks = [-1 -0.5 0 0.5 1];
end

function updateGauge(src,event,fig)
    c=1;
    lambda=event.Value;
    if abs(lambda)<0.03
        lambda=0;
    end
    f= @(t,x)[x(2);-x(1)-lambda*x(2)];
    intervalo=[0,100];
    N=10000;
    figura=figure(1);
    figura.Position = [800, 150, 750, 750];
    brown=[171 104 87]./255;
    plot([0 0], [-4 4],'k');  %x-axis
    hold on
    plot([-4 4], [0 0],'k');  %y-axis
    if lambda<0
        %There are not periodic orbits      
        % Solution with x0=[1,0];
        x0=[1,0];
        [~,x]=ode45(f,intervalo,x0,N);
        h1=plot(x(:,1),x(:,2),'m');        
        hold on 
        scatter(x0(1),x0(2),'m')
        % Solution with x0=[-1,0];
        x0=[-1,0];
        [~,x]=ode45(f,intervalo,x0,N);
        h3=plot(x(:,1),x(:,2),'c');
        scatter(x0(1),x0(2),'c')
        % Equilibrium point unstable
        h2=scatter(0,0,'r','filled');
        legend([h2 h3 h1],'Punto de equilibrio inestable','Solución con dato inicial (1,0)','Solución con dato inicial (-1,0)')
    elseif lambda==0
        % All the orbits are periodic.
        % Solution with x0=[1,0];        
        x0=[1,0];
        [~,x]=ode45(f,intervalo,x0,N);
        h2=plot(x(:,1),x(:,2),'m');
        hold on 
        % Solution with x0=[0.5,0]   
        x0=[0.5,0];
        [~,x]=ode45(f,intervalo,x0,N);
        h3=plot(x(:,1),x(:,2),'c');
        % Equilibrium point stable
        h1=scatter(0,0,'yellow','filled'); 
        legend([h1 h2 h3],'Punto de equilibrio estable','Órbita periódica de radio 1','Órbita periódica de radio 1/2');
    elseif lambda>0
        %There are not periodic orbits      
        % Solution with x0=[1,0];
        x0=[1,0];
        [~,x]=ode45(f,intervalo,x0,N);
        h1=plot(x(:,1),x(:,2),'m');        
        hold on         
        scatter(x0(1),x0(2),'m')
        x0=[-1,0];
        [~,x]=ode45(f,intervalo,x0,N);
        h3=plot(x(:,1),x(:,2),'c');
        scatter(x0(1),x0(2),'c')
        % Equilibrium point as. stable
        h2=scatter(0,0,'g','filled');
        legend([h2 h1 h3],'Punto de equilibrio as. estable','Solución con dato inicial (1,0)','Solución con dato inicial (-1,0)')
    end
    xlim([-2 2])
    ylim([-2 2])
    title('Trayectoria de la solución')
    subtitle(strcat('\lambda=',sprintf('%0.2f',lambda)));
    %axis equal
    hold off
    %Mostrar lambda
    %Mostrar leyenda
end