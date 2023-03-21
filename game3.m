% (MAIN) Script that runs the Snake game. (v0.4)
% Jin Rhee

%% Main function (runs snake game)
function game3()

    %--------- Initial game variables ---------%
    quit_game = 0;  % Game quit flag
    reason = 0; % Game quit reason (1: user quit, 2: snake death, 3: absolute completion)
    direction = 2; % Initial snake direction
    speed = 0.05; % Delay time

    board_limit = 8; % Defines board size
    snake_pos = randi([round(-board_limit/2),round(board_limit/2)]) + [1, 0; 0, 0]; % Sets random initial snake position
    snake_head = [snake_pos(1,1); snake_pos(2,1)];  % Sets initial head position
    [~, snake_length] = size(snake_pos);   % Sets initial snake length
    food_pos = randi([-board_limit, board_limit-1],[2,1]);  % Sets initial food position

    %--------- Close all open figures ---------%
    close all
    
    %--------- Open figure and set nice background ---------%
    figure('Color', 'k', 'KeyPressFcn',@callback);
    set(gca, 'Color', [0.15,0.15,0.15], 'XColor', [0.1,0.1,0.1], 'YColor', [0.1,0.1,0.1]);

    %--------- Callback function to determine user input ---------%
    function callback(~, event)
        disp(event.Key)
        switch event.Key    % Switch-case to determine user quit and snake direction input
            case 'escape' % Quit game
                quit_game = 1;
                reason = 1;
            case 'leftarrow' % Left arrow
                if (direction ~= 2) % Prevent snake from eating itself
                    direction = 1;
                end
            case 'rightarrow' % Right arrow
                if (direction ~= 1) % Prevent snake from eating itself
                    direction = 2;
                end
            case 'uparrow' % Up arrow
                if (direction ~=  4) % Prevent snake from eating itself
                    direction = 3;
                end
            case 'downarrow' % Down arrow
                if (direction ~= 3) % Prevent snake from eating itself
                    direction = 4;
                end
        end
    end
    
    %--------- Start screen and text ---------%
    t1 = text(0.11,0.51,'SNAKE','color',[0.5,0.5,0.5],'fontsize',board_limit*10);
    t2 = text(0.1,0.5,'SNAKE','color',[0.8,0.8,0.8],'fontsize',board_limit*10);
    t3 = text(0.13,0.35,'Press any key to start', 'color',[0.8,0,0],'fontsize',board_limit*2);
    t4 = text(0.01,0.01,'v0.4     Written by Jin Rhee','color',[0.8,0.8,0.8],'fontsize',board_limit);
    
    waitforbuttonpress  % Pause script until user presses button

    delete(t1); % Delete text objects
    delete(t2);
    delete(t3);
    delete(t4);

    %% Main recursion (dies upon exit condition)
    while (~quit_game)

        %--------- Draw snake using previous position coords and fix axes ---------%
        drawframe(snake_pos, snake_length, food_pos);
        
        %--------- Fix figure axes ---------%
        axis([-2*board_limit,board_limit*2-1,-2*board_limit,board_limit*2-1]);
        axis square manual
        
        %--------- Score and speed counter ---------%
        text(board_limit*2+0.1,0,'Score:','color',[1,1,1], 'fontsize',10);
        text(board_limit*2+3,0,num2str(snake_length-2),'color',[1,1,1]);
        text(board_limit*2+0.1,-1,'Speed:','color',[1,1,1], 'fontsize',10);
        text(board_limit*2+3.2,-1,num2str(speed),'color',[1,1,1]);
        
        
        %--------- Update snake_head coords according to input direction ---------%
        switch direction    
            case 1
                snake_head(1,1) = snake_head(1,1)-1;    % Decrease snake_head x pos by 1
            case 2
                snake_head(1,1) = snake_head(1,1)+1;    % Increase snake_head x pos by 1
            case 3
                snake_head(2,1) = snake_head(2,1)+1;    % Increase snake_head y pos by 1
            case 4
                snake_head(2,1) = snake_head(2,1)-1;    % Decrease snake_head y pos by 1
        end
        
        %--------- Food collision detection ---------%
        if (snake_head == food_pos) 
            food_pos = randi([-board_limit, board_limit-1],[2,1]);  % Set new food position
            snake_pos = [snake_pos,snake_pos(:,end)];   % Lengthens snake_pos array by 1
            [~, snake_length] = size(snake_pos);    % Updates snake_length
        end
        
        %--------- Snake death detection and death command ---------%
        death_flag = ...    % Death flag for wall collision and self collision
            snake_head(1,1) == board_limit*2-1|...      % Right wall collision detection
            (snake_head(1,1) == -1-board_limit*2)|...   % Left wall
            (snake_head(2,1) == board_limit*2-1)|...    % Top wall
            (snake_head(2,1) == -1-board_limit*2)|...   % Bottom wall
            ...
            (sum(...        % Self collision detection
                (snake_pos(1,2:end) == snake_head(1,1))...  % Boolean array whether snake_head x-pos matches 
                &(snake_pos(2,2:end) == snake_head(2,1))... % Boolean array whether snake_head y-pos matches
            ) > 0); % Sum is greater than 1 if snake_head matches any snake_pos coordinate

        if death_flag   % Run upon death
            quit_game = 1;  % Update quit_game flag
            if (snake_length == (board_limit*2)^2-1)   % Update reason as absolute completion
                reason = 3;
            else
                reason = 2; % Update reason as snake death
            end
            break;  % Stop game
        end

        %--------- Update snake position coords ---------%
        for n = 0:snake_length-2    % Move snake along by shifting limb coords back by 1
            snake_pos(:,end-n) = snake_pos(:,end-n-1);
        end
        
        snake_pos(:,1) = snake_head(:,1);   % Manually input new snake head coords into first index of snake_pos

        %--------- Pause ---------%
        pause(speed);   % Pause frame for specified time
    end
    
    %--------- Run upon game end ---------%
    deathanimation(snake_pos, snake_length);    % Play death animation
    
    axis([-2*board_limit,board_limit*2-1,-2*board_limit,board_limit*2-1]);  %Set figure axes after death animation
    axis square manual

    switch reason    % Display game over message with reason
        case 1
            msgbox("User quit!");
        case 2
            msgbox("You died!");
        case 3
            msgbox("You are a god!");
    end
    
    pause(2)
    close all   % Close all windows after delay

end

%% Draw frame function (makes use of translateShape function)
function drawframe(snake_pos, snake_length, food_pos)
    
    %--------- Snake limb and apple shape definition ---------%
    snake_limb = [0, 0, 1, 1; 0, 1, 1, 0];
    apple = [0.5, 0.5, 0.5, 0.5; 0.5, 0.5, 0.5, 0.5] + [-0.5, 0, 0.5, 0; 0, -0.5, 0, 0.5]*1.5;
    
    %--------- Clear previous frame and set background---------%
    clf;
    hold on
    set(gca, 'Color', [0.15,0.15,0.15], 'XColor', [0.1,0.1,0.1], 'YColor', [0.1,0.1,0.1]);

    %--------- Draw snake limbs ---------%
    for n = 1:snake_length
        switch ~mod(n,2)    % Alternate snake limb colour
            case 0
                colour = [0.3294, 0.3922, 0.6196];
            case 1
                colour = [0.6510, 0.6510, 0.6510];
        end
        new_snake_limb = translateShape(snake_limb, snake_pos(1,n), snake_pos(2,n));    % Translate snake limbs
        fill(new_snake_limb(1,:), new_snake_limb(2,:), colour, 'LineStyle','none'); % Draw limbs onto figure
    end

    %--------- Draw apples ---------%
    new_food_pos = translateShape(apple, food_pos(1), food_pos(2)); % Translate apples
    fill(new_food_pos(1,:), new_food_pos(2,:), [0.7,0.2,0.2], 'LineStyle', 'none');   % Draw apple onto figure
    hold off
end

%% Snake death animation %%
function deathanimation(snake_pos, snake_length)
    %--------- Snake limb and GAME OVER shape definition ---------%
    snake_limb = [0, 0, 1, 1; 0, 1, 1, 0];

    g = [1,2;1,3;1,4;1,5;2,1;2,6;3,1;3,6;4,1;4,4;4,6;5,2;5,3;5,4];  % 15 minutes horribly spent
    a = [1,1;1,2;1,3;1,4;2,3;2,5;2,6;3,3;3,6;4,3;4,5;4,6;5,1;5,2;5,3;5,4];
    m = [1,1;1,2;1,3;1,4;1,5;1,6;2,5;3,4;4,5;5,1;5,2;5,3;5,4;5,5;5,6];
    e = [1,1;1,2;1,3;1,4;1,5;1,6;2,1;2,4;2,6;3,1;3,4;3,6;4,1;4,4;4,6];
    o = [1,2;1,3;1,4;1,5;2,1;2,6;3,1;3,6;4,1;4,6;5,2;5,3;5,4;5,5];
    v = [1,4;1,5;1,6;2,2;2,3;3,1;4,2;4,3;5,4;5,5;5,6];
    r = [1,1;1,2;1,3;1,4;1,5;1,6;2,3;2,6;3,3;3,6;4,2;4,3;4,6;5,1;5,2;5,4;5,5];

    game = [g;[a(:,1)+6,a(:,2)];[m(:,1)+12,m(:,2)];[e(:,1)+18,e(:,2)]];
    over = [o;[v(:,1)+6,v(:,2)];[e(:,1)+12,e(:,2)];[r(:,1)+17,r(:,2)]];

    gameover = ([[game(:,1),game(:,2)+10];over] - 4) * 0.2 - 2; % GAMEOVER shape, scaled by 0.2 and centered (pretty much)

    %--------- Set background---------%
    set(gca, 'Color', [0.15,0.15,0.15], 'XColor', [0.1,0.1,0.1], 'YColor', [0.1,0.1,0.1]);

    %--------- Draw snake limbs ---------%
    hold on
    for n = 1:snake_length
        new_snake_limb = translateShape(snake_limb, snake_pos(1,n), snake_pos(2,n));    % Translate snake limbs
        fill(new_snake_limb(1,:), new_snake_limb(2,:), [0.7,0.2,0.2], 'LineStyle','none'); % Draw limbs onto figure
        pause(0.03) % Pause for rippling effect
    end
    hold off
    
    %--------- Draw game over ---------%
    hold on
    for n = 1:length(gameover)
        new_snake_limb = translateShape(snake_limb*0.2, gameover(n,1), gameover(n,2));  % Translate (reused) snake limbs
        fill(new_snake_limb(1,:), new_snake_limb(2,:), 'r', 'LineStyle', 'none');   % Draw GAME OVER onto figure
        pause(0.03) % Pause for rippling effect
    end
    hold off
end