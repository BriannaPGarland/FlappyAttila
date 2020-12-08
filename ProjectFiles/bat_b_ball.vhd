--bat_n_ball final draft
-- bird = bat
-- ball = gap
-- wall = bound
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
		bat_x : IN STD_LOGIC_VECTOR (10 DOWNTO 0); -- current bat x position
		serve : IN STD_LOGIC; -- initiates serve
		red : OUT STD_LOGIC;
		green : OUT STD_LOGIC;
		blue : OUT STD_LOGIC
	);
END bat_n_ball;

ARCHITECTURE Behavioral OF bat_n_ball IS
	SIGNAL gapsize : INTEGER := 120; -- gap size in pixels
	CONSTANT bat_w : INTEGER := 6; -- bat width in pixels
	CONSTANT bat_h : INTEGER := 6; -- bat height in pixels
	CONSTANT bound_h : INTEGER := 65; -- thickness of the bound
	SIGNAL score : integer :=0; -- score;+1for each bound passed
	-- distance gap moves each frame
	SIGNAL gap_speed : STD_LOGIC_VECTOR (9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR (5, 10);
	SIGNAL bound_on : STD_LOGIC; -- indicates whether bound is at current pixel position
	SIGNAL bat_on : STD_LOGIC; -- indicates whether bat at over current pixel position
	signal building_on : std_logic;
	SIGNAL game_on : STD_LOGIC := '0'; -- indicates whether gap is in play
	-- current gap position - intitialized to center of screen
	SIGNAL gap_pos : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(640, 10);
	SIGNAL bound_y : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(5, 10);-- might need to mess around with the height
	-- bird = bat  vertical position
	CONSTANT bat_y : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 10);
	-- current gap motion - initialized to (+ gap_speed) pixels/frame in both X and Y directions
	--boundary on the gap
	SIGNAL bound_y_motion : STD_LOGIC_VECTOR(9 DOWNTO 0) := gap_speed;
	SIGNAL x : integer :=320;
	SIGNAL flag : integer :=0;
	SIGNAL hitcount : STD_LOGIC_VECTOR(15 DOWNTO 0);
	--signal duck_x : integer := 115; --constant duck x position
    --signal duck_y : integer := 150; --initial duck y position
    --signal duck_top, duck_bottom, duck_left, duck_right : integer := 0; 
BEGIN
	red <=  NOT bat_on;   -- color setup for red gap and cyan bat on white background	
	green <= NOT bound_on;
	blue <= NOT bound_on AND building_on;
	-- process to draw gap
	-- set gap_on if current pixel address is covered by gap position
	gapdraw : PROCESS (bound_y, gap_pos, pixel_row, pixel_col) IS
		VARIABLE vx, vy : STD_LOGIC_VECTOR (9 DOWNTO 0);
	BEGIN
        IF ((pixel_row >= gap_pos - gapsize/2) OR (gap_pos <= gapsize/2)) AND
		 pixel_row <= gap_pos + gapsize/2 AND
			 pixel_col >= bound_y - bound_h AND
			 pixel_col <= bound_y + bound_h THEN
				bound_on <= '1';
		ELSE
			bound_on <= '0';
		END IF;
	END PROCESS;
	
	--process to draw the buildings
	buldingdraw: PROCESS (bound_y, gap_pos, pixel_row, pixel_col) IS
		VARIABLE vx, vy : STD_LOGIC_VECTOR (9 DOWNTO 0);
	BEGIN
        IF ((pixel_row < gap_pos - gapsize/2) OR (gap_pos > gapsize/2)) AND
		( pixel_row > gap_pos + gapsize/2 OR 
		 pixel_row < gap_pos + gapsize/2)  AND
			 pixel_col >= bound_y - bound_h AND
			 pixel_col <= bound_y + bound_h THEN
				building_on <= '1';
		ELSE
			building_on <= '0';
		
		END IF;
	END PROCESS;
	
	--process to draw bat
    -- set bat_on if current pixel address is covered by bat position
	batdraw : PROCESS (bat_x, pixel_row, pixel_col) IS
		VARIABLE vx, vy : STD_LOGIC_VECTOR (9 DOWNTO 0);
	
	BEGIN
		IF ((pixel_row >= bat_x - bat_w) OR (bat_x <= bat_w)) AND
		 pixel_row <= bat_x + bat_w AND
			 pixel_col >= bat_y - bat_h AND
			 pixel_col <= bat_y + bat_h THEN
				bat_on <= '1';
		ELSE
			bat_on <= '0';
	   END IF;
	END PROCESS;
	
		
		-- process to move gap once every frame (i.e. once every vsync pulse)
		mgap : PROCESS
			VARIABLE temp : STD_LOGIC_VECTOR (10 DOWNTO 0);
		BEGIN
			WAIT UNTIL rising_edge(v_sync);
			IF serve = '1' AND game_on = '0' THEN -- test for new serve
			    score<=0;
			    hitcount<= hitcount-hitcount;
			    gapsize<=120;
			    gap_speed<=CONV_STD_LOGIC_VECTOR (5, 10);
				game_on <= '1';
				bound_y_motion <= (gap_speed); -- set vspeed to (- gap_speed) pixels
			ELSIF 
		      bound_y + bound_h/2 >= 900 THEN -- if gap meets bottom bound
			    IF flag=0 THEN
			    score <= score+1;
			    flag <=1;
			  END IF;  
			    
			    x <=((123*(score**2)) mod 560)+40;
			    IF x<40 THEN
			    x <=40;
			    ELSIF x>600 THEN
			    x <=600;
			    END IF;
			    gap_pos <= CONV_STD_LOGIC_VECTOR(x, 10);
				bound_y <= CONV_STD_LOGIC_VECTOR(5, 10);
			    flag <=0;
				
				
			END IF;
			-- landed within the gap
			IF bound_y <= bat_y + bat_h/2 AND
			 bound_y >= bat_y - bat_h/2 THEN
                IF (bat_x + bat_w/2) <= (gap_pos + gapsize/2) AND
                 (bat_x - bat_w/2) >= (gap_pos - gapsize/2) Then
                    hitcount <= hitcount+1;
                    hits <= hitcount; 
                 
                        
                     -- gap_speed<=CONV_STD_LOGIC_VECTOR (0, 10);
                     --(bat_y + bat_h/2) >= (bound_y - bound_h) AND
                     --(bat_y - bat_h/2) <= (bound_y + bound_h) THEN
                     --nothing, it's all good   
                ELSE
                -- hit the bound you lose
           
                game_on <= '0';
                score <= 0;
                hitcount <= hitcount-hitcount;
                
			    gap_pos <= CONV_STD_LOGIC_VECTOR(x, 10);
			    
                gapsize<=120;
			    gap_speed<=CONV_STD_LOGIC_VECTOR (5, 10);
			    bound_y_motion<=gap_speed;
			    
                END IF;
            END IF;
			
			-- compute next gap vertical position
			-- variable temp adds one more bit to calculation to fix unsigned underflow problems
			-- when gap_y is close to zero and gap_y_motion is negative(This is not needed)
			temp := ('0' & bound_y) + (bound_y_motion(9) & bound_y_motion);
			IF game_on = '0' THEN
				bound_y <= CONV_STD_LOGIC_VECTOR(5, 10);
			ELSIF temp(10) = '1' THEN
				bound_y <= (OTHERS => '0');
			ELSE bound_y <= temp(9 DOWNTO 0);
			END IF;
			
			END PROCESS;
END Behavioral;
