% Projekt Mobile Mapping

%% Aquire Webcam Object

zed = webcam;

preview(zed);

%% Clear webcam connection
cleanZed = onCleanup(@() clear(zed));