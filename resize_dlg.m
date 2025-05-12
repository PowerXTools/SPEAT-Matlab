% Function: resize_dlg
% Resize dialog boxes and text
% Input: dialog box handle, dialog width
% Output: no output


function resize_dlg(dlg,dlg_width)

dlg.Visible="off";   % hide the dialog first
dlgChildren = get(dlg, 'Children');   % retrieves the child component of the dialog box
msgText = findall(dlgChildren, 'Type', 'Text');   % finds all text components in the dialog box
set(msgText, 'FontSize',11);   % set the font size of the text component to 11
dlgButton = findobj(dlg, 'Type', 'UIControl');   % finds UI control components in a dialog box, including buttons
set(dlgButton, 'String', 'OK');

dlg_hdl = findobj(dlg, 'Type', 'figure');   % gets the handle to the dialog box
msg_width = dlg_width * 8;   % sets the width of the message text

% Add some extra width to accommodate other content such as titles and buttons
dlg_hdl.Position(3) = msg_width + 100;
dlg_hdl = findobj(dlg, 'Type', 'figure');   % gets the dialog handle
dlgButton.Position(1) = (dlg_hdl.Position(3) - dlgButton.Position(3)) / 2;
dlg.Visible="on";   % show dialog box

end

