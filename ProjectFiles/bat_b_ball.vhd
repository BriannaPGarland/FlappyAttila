--bat_n_ball final draft
-- bird = bat
--ball = gap
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY bat_n_ball IS
	PORT (
		v_sync : IN STD_LOGIC;
		pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		hits: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		bird_x : IN STD_LOGIC_VECTOR (10 DOWNTO 0); -- current bird x position
		serve : IN STD_LOGIC; -- initiates serve
		red : OUT STD_LOGIC;
		green : OUT STD_LOGIC;
		blue : OUT STD_LOGIC
	);
END bat_n_ball;

ARCHITECTURE Behavioral OF bat_n_ball IS
	SIGNAL gapsize : INTEGER := 120; -- ball size in pixels
	CONSTANT bird_w : INTEGER := 6; -- bird width in pixels
	CONSTANT bird_h : INTEGER := 6; -- bird height in pixels
	CONSTANT wall_h : INTEGER := 65; -- thickness of the wall
	SIGNAL score : integer :=0; -- score;+1for each wall passed
	-- distance ball moves each frame
	SIGNAL ball_speed : STD_LOGIC_VECTOR (9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR (5, 10);
	SIGNAL wall_on : STD_LOGIC; -- indicates whether wall is at current pixel position
	SIGNAL bird_on : STD_LOGIC; -- indicates whether bird at over current pixel position
	signal building_on : std_logic;
	SIGNAL game_on : STD_LOGIC := '0'; -- indicates whether ball is in play
	-- current ball position - intitialized to center of screen
	SIGNAL gap_pos : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(640, 10);
	SIGNAL wall_y : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(5, 10);-- might need to mess around with the height
	-- bird = bat  vertical position
	CONSTANT bird_y : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 10);
	-- current ball motion - initialized to (+ ball_speed) pixels/frame in both X and Y directions
	--boundary on the gap
	SIGNAL wall_y_motion : STD_LOGIC_VECTOR(9 DOWNTO 0) := ball_speed;
	SIGNAL x : integer :=320;
	SIGNAL flag : integer :=0;
	SIGNAL hitcount : STD_LOGIC_VECTOR(15 DOWNTO 0);
	--signal duck_x : integer := 115; --constant duck x position
    --signal duck_y : integer := 150; --initial duck y position
    --signal duck_top, duck_bottom, duck_left, duck_right : integer := 0; 
BEGIN
	red <= NOT bird_on;   -- color setup for red ball and cyan bird on white background	
	green <= NOT wall_on;
	blue <= NOT wall_on AND building_on;
	-- process to draw gap
	-- set ball_on if current pixel address is covered by ball position
	balldraw : PROCESS (wall_y, gap_pos, pixel_row, pixel_col) IS
		VARIABLE vx, vy : STD_LOGIC_VECTOR (9 DOWNTO 0);
	BEGIN
        IF ((pixel_row >= gap_pos - gapsize/2) OR (gap_pos <= gapsize/2)) AND
		 pixel_row <= gap_pos + gapsize/2 AND
			 pixel_col >= wall_y - wall_h AND
			 pixel_col <= wall_y + wall_h THEN
				wall_on <= '1';
		ELSE
			wall_on <= '0';
		END IF;
	END PROCESS;
	
	--process to draw the buildings
	buldingdraw: PROCESS (wall_y, gap_pos, pixel_row, pixel_col) IS
		VARIABLE vx, vy : STD_LOGIC_VECTOR (9 DOWNTO 0);
	BEGIN
        IF ((pixel_row < gap_pos - gapsize/2) OR (gap_pos > gapsize/2)) AND
		 pixel_row > gap_pos + gapsize/2 AND
			 pixel_col >= wall_y - wall_h AND
			 pixel_col <= wall_y + wall_h THEN
				building_on <= '1';
		ELSE
			building_on <= '0';
		END IF;
	END PROCESS;
	
	--process to draw bird
    -- set bird_on if current pixel address is covered by bird position
	birddraw : PROCESS (bird_x, pixel_row, pixel_col) IS
		VARIABLE vx, vy : STD_LOGIC_VECTOR (9 DOWNTO 0);
	
	BEGIN
		IF ((pixel_row >= bird_x - bird_w) OR (bird_x <= bird_w)) AND
		 pixel_row <= bird_x + bird_w AND
			 pixel_col >= bird_y - bird_h AND
			 pixel_col <= bird_y + bird_h THEN
				bird_on <= '1';
		ELSE
			bird_on <= '0';
	   END IF;
	END PROCESS;
	
		
		-- process to move ball once every frame (i.e. once every vsync pulse)
		mball : PROCESS
			VARIABLE temp : STD_LOGIC_VECTOR (10 DOWNTO 0);
		BEGIN
			WAIT UNTIL rising_edge(v_sync);
			IF serve = '1' AND game_on = '0' THEN -- test for new serve
			    score<=0;
			    gapsize<=120;
			    ball_speed<=CONV_STD_LOGIC_VECTOR (5, 10);
				game_on <= '1';
				wall_y_motion <= (ball_speed); -- set vspeed to (- ball_speed) pixels
		--	ELSIF 
			--wall_y + wall_h/2 >= 480 THEN -- if ball meets bottom wall
			    --IF flag=0 THEN
			   -- score <= score+1;
			   -- flag <=1;
			 -- END IF;
			    --gapsize is decreased and speed is increased;
			    --if '=' doesn't work try '<' and work from 5 to 15 to 25
			    --IF score=5 THEN
			    --    gapsize<=70;
			    --    ball_speed<=CONV_STD_LOGIC_VECTOR (6, 10);
			    --ELSIF score=15 THEN
			    --    gapsize<=60;
			    --    ball_speed<=CONV_STD_LOGIC_VECTOR (5, 10);
			    --ELSIF score=25 THEN
			    --    gapsize<=50;
			    --    ball_speed<=CONV_STD_LOGIC_VECTOR (6, 10);
			    --END IF;
			    --wall_y_motion<=ball_speed;
			    --get a new x-position for the gap with each reset
			    --x <=((abs(320-x))+(123*(score**2)) mod 560)+40;
			    --trying without the initial abs(320-x);
			    --This somehow creates a random number, don't ask me how
			    x <=((123*(score**2)) mod 560)+40;
			    IF x<40 THEN
			    x <=40;
			    ELSIF x>600 THEN
			    x <=600;
			    END IF;
			    gap_pos <= CONV_STD_LOGIC_VECTOR(x, 10);
				wall_y <= CONV_STD_LOGIC_VECTOR(5, 10);
				flag<=0;
			END IF;
			-- landed within the gap
			IF wall_y <= bird_y + bird_h/2 AND
			 wall_y >= bird_y - bird_h/2 THEN
                IF (bird_x + bird_w/2) <= (gap_pos + gapsize/2) AND
                 (bird_x - bird_w/2) >= (gap_pos - gapsize/2) Then
                    score <= score+1;
                    hitcount <= hitcount+1;
                    hits <= hitcount; 
                     -- ball_speed<=CONV_STD_LOGIC_VECTOR (0, 10);
                     --(bird_y + bird_h/2) >= (wall_y - wall_h) AND
                     --(bird_y - bird_h/2) <= (wall_y + wall_h) THEN
                     --nothing, it's all good   
                ELSE
                -- hit the wall you lose
           
                game_on <= '0';
                gap_pos <= CONV_STD_LOGIC_VECTOR(320, 10);
                gapsize<=120;
			    ball_speed<=CONV_STD_LOGIC_VECTOR (5, 10);
			    wall_y_motion<=ball_speed;
			    
                END IF;
            END IF;
			
			-- compute next ball vertical position
			-- variable temp adds one more bit to calculation to fix unsigned underflow problems
			-- when ball_y is close to zero and ball_y_motion is negative(This is not needed)
			temp := ('0' & wall_y) + (wall_y_motion(9) & wall_y_motion);
			IF game_on = '0' THEN
				wall_y <= CONV_STD_LOGIC_VECTOR(5, 10);
			ELSIF temp(10) = '1' THEN
				wall_y <= (OTHERS => '0');
			ELSE wall_y <= temp(9 DOWNTO 0);
			END IF;
			
			END PROCESS;
END Behavioral;
