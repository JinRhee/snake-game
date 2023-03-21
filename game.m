% Script that runs the Snake game. (v0.1)
% Jin Rhee
function game()
    % Close all figures
    close all

    % Flag variables
    direction = 0;
    quit_game = 0;

    % Game setting variables
    board_unit = 5;
    board_unit_count = 40;
    board_limit = board_unit*board_unit_count/2;

    % Defining the figure and keyboard input
    figure('KeyPressFcn',@my_callback);
    function my_callback(obj, event)
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

    axis([-100,100,-100,100]);
    axis square

    % Main recursive script
    while (quit_game ~= 1)
        switch direction
            case 0
                drawframe(0,0,0,0)
            case 1
                drawframe(-5,0,0,0);
            case 2
                drawframe(5,0,0,0);
            case 3
                drawframe(0,5,0,0);
            case 4
                drawframe(0,-5,0,0);
        end
    end
    
    close all
    disp("You lose!");
end

% drawframe draws snake and food onto figure
function drawframe(snake_x, snake_y, food_x, food_y)
    snake_limb = [0, 0, 5, 5; 0, 5, 5, 0];

    new_snake_limb = translateShape(snake_limb,snake_x,snake_y);
    fill(new_snake_limb(1,:), new_snake_limb(2,:),'r');
    axis([-100,100,-100,100]);
    axis square
    pause(1);
end
