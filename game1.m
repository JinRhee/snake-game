% Script that runs the Snake game. (v0.2)
% Jin Rhee
function game1()
    % Close all open figures
    close all

    % Flag variables
    direction = 1;
    quit_game = 0;
    difficulty = 4;
    snake_length = 3;
    snake_pos = [-10 -5 0;0 0 0];
    snake_head = [snake_pos(1,1); snake_pos(2,1)];

    % Game setting variables
    board_unit = 5;
    board_unit_count = 40;
    board_limit = board_unit*board_unit_count/2;

    % Defining the figure and keyboard input
    figure('KeyPressFcn',@callback);
    function callback(~, event)
        switch event.Key
            case 'escape' % Quit game
                quit_game = 1;
                disp(quit_game);
            case 'leftarrow' % Left arrow
                direction = 1;
                disp('left');
            case 'rightarrow' % Right arrow
                direction = 2;
                disp('right');
            case 'uparrow' % Up arrow
                direction = 3;
                disp('up');
            case 'downarrow' % Down arrow
                direction = 4;
                disp('down');
        end
    end

    axis([-1*board_limit,board_limit,-1*board_limit+board_unit,board_limit-board_unit]);
    axis square

    %% Main recursive script: runs until exit condition is met (i.e. user quit or snake death)
    while (quit_game ~= 1)
        
        % Draw snake using previous position coords
        drawframe(snake_pos, snake_length, 0, 0);

        % Snake lengthening determination
        % Death determination

        % Store new snake head coords according to user input direction
        switch direction
            case 1
                if (direction ~= 2)
                    snake_head(1,1) = snake_head(1,1)-board_unit;
                end
            case 2
                if (direction ~= 1)
                    snake_head(1,1) = snake_head(1,1)+board_unit;
                end
            case 3
                if (direction ~= 4)
                    snake_head(2,1) = snake_head(2,1)+board_unit;
                end
            case 4
                if (direction ~= 3)
                    snake_head(2,1) = snake_head(2,1)-board_unit;
                end
        end
        
        % Move snake along by shifting limb coords back by 1
        for n = 0:snake_length-2
            snake_pos(:,end-n) = snake_pos(:,end-n-1);
        end
        % Manually input new snake head coords into first index of snake_pos
        snake_pos(:,1) = snake_head(:,1);
        
        % Fix figure axes
        axis([-1*board_limit,board_limit,-1*board_limit+board_unit,board_limit-board_unit]);
        axis square

        % Pause
        pause((5-difficulty)*0.07);
    end
    
    close all
    disp("Game over!");
end

function drawframe(snake_pos, snake_length, food_x, food_y)
    snake_limb = [0, 0, 5, 5; 0, 5, 5, 0];
    clf;
    hold on
    for n = 1:snake_length
        new_snake_limb = translateShape(snake_limb, snake_pos(1,n), snake_pos(2,n));
        fill(new_snake_limb(1,:), new_snake_limb(2,:),'r');
    end
    hold off
end
