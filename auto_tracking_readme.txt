

Outline filaments
	- use segmented lines in FIJI, trace from (-) end to (+) end.
	- export using the exportROI plugin

Track particles using uTrack
	- Track single particles
	- Accept default settings (Gaussian standard deviation of 2 px)
		- use rolling-window time averaging (3 frame window size): Improves detection of flickering motors.
	- Motion analysis: analyze asymmetric tracks (accept default settings)
	- The motion analysis generates a file with classified runs ([Movie Directory]/TrackingPackage/MotionAnalysis/channel_1.mat). Open this workspace, which should contain structs called diffAnalysisRes and tracks.

Import the rois generated in ImageJ
	
	>> rois = read_in_rois;
	
	(follow the dialog to select the .txt file)

	output: 
		- rois, a cell array that contains the coordinates of all the marked filaments.

Select tracks that travel along filaments
	
	>> [coords, filrois] = tracks_to_coords(tracks, rois, 5, 10);
	
	This selects tracks that are no more than 5 pixels from the closest filament, but which may start up to 10 pixels away from the filament end

	output: 
		- coords, a cell array containing xy-coordinates for every run which is on a filament.
		- filrois, a cell array containing the xy-coordinates for the filament associated with each run. This is important because it helps establish run polarity.

Navigate to the directory where you want all the run files saved.

Project the tracks onto their given filaments and save as a txt file like the one exported by Tony's analysis

	>> coords_to_runcalc(coords, filrois, 1.0356)

	(if the frame time is 1.0356s). The length units here will be given in pixels still.

These resulting files could be analyzed using Tony's run analysis software or the piecewise-linear code.


If piecewise-linear code:

	>> velocities = parallel_velocity_fit_folder;

	(select folder, allow fitting to run)
	(Still in units of px/s)

	>> plot_velocity_histogram(velocities, 0, 0)

	function is plot_velocity_histogram(velocities, unsigned, mostly_unidirectional)
	unsigned should be 1 when the filaments are unsigned; mostly_unidirectional should be 1 when the motor is expected to be mostly unidirectional.

	If unsigned & not mostly unidirectional, plots a histogram of speeds (abs(velocities))

	If unsigned & mostly unidirectional, each run is considered to have a net positive displacement, and the signs of corresponding velocities are adjusted to fit this.

	Else if not unsigned, the velocities are plotted as computed before.