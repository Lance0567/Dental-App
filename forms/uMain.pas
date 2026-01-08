unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.MultiView, FMX.TabControl, FMX.StdCtrls,
  FMX.Objects, uDashboard, FMX.ImgList, uPatients, uAppointments, uPatientModal,
  uUsers, uUserProfile, uUserModal, System.Skia, FMX.Skia, FMX.Ani, FireDAC.Stan.Param,
  FMX.Effects, FMX.Grid, Data.DB, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  Fmx.Bind.Grid, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, uAppointmentModal,
  uUserDetails, FMX.DialogService, uUpdateProfilePhoto, uContactInfo;

type
  TfrmMain = class(TForm)
    lytContainer: TLayout;
    lytSidebar: TLayout;
    mvSidebar: TMultiView;
    sbMenu: TSpeedButton;
    sbAppointments: TSpeedButton;
    sbDashboard: TSpeedButton;
    sbPatients: TSpeedButton;
    lytContent: TLayout;
    lytMenuH: TLayout;
    fDashboard: TfDashboard;
    tcController: TTabControl;
    tiDashboard: TTabItem;
    tiPatients: TTabItem;
    tiAppointments: TTabItem;
    fAppointments: TfAppointments;
    fPatientModal: TfPatientModal;
    lDivider: TLine;
    lbMainMenu: TLabel;
    sbUsers: TSpeedButton;
    tiUsers: TTabItem;
    tiUserProfile: TTabItem;
    lytPopUpBottom: TLayout;
    lytPopUpMessage: TLayout;
    rPopUp: TRectangle;
    FloatAnimation1: TFloatAnimation;
    gPopUp: TGlyph;
    Timer1: TTimer;
    lbPopUp: TSkLabel;
    fUsers: TfUsers;
    ShadowEffect1: TShadowEffect;
    fUserProfile: TfUserProfile;
    fPatients: TfPatients;
    fContactInfo: TfContactInfo;
    fUpdateProfilePhoto: TfUpdateProfilePhoto;
    fUserDetails: TfUserDetails;
    ShadowEffect2: TShadowEffect;
    fUserModal: TfUserModal;
    fAppointmentModal: TfAppointmentModal;
    procedure FormCreate(Sender: TObject);
    procedure mvSidebarResize(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure sbPatientsClick(Sender: TObject);
    procedure sbDashboardClick(Sender: TObject);
    procedure sbAppointmentsClick(Sender: TObject);
    procedure fPatientsbtnAddNewPatientClick(Sender: TObject);
    procedure fDashboardbtnNewPatientClick(Sender: TObject);
    procedure fDashboardbtnNewAppointmentClick(Sender: TObject);
    procedure fUsers1btnAddNewUserClick(Sender: TObject);
    procedure sbUsersClick(Sender: TObject);
    procedure fPatientModalbtnSavePatientClick(Sender: TObject);
    procedure FloatAnimation1Finish(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tcControllerChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure fDashboardsbListClick(Sender: TObject);
  private
    procedure QueryHandler;
    procedure ButtonPressedResetter;
    { Private declarations }
  public
    procedure Dashboard;
    procedure HideFrames;
    procedure ButtonPressedReset;
    procedure RecordMessage(const AEntity, ADetail: string);
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses uDm, uLogin, uToolbar;

{ Hide Frames }
procedure TfrmMain.HideFrames;
begin
  fDashboard.Visible := False;
  fPatients.Visible := False;
  fAppointments.Visible := False;
  fUsers.Visible := False;
  fUserProfile.Visible := False;
end;

{ Hide Button highlight navbar }
procedure TfrmMain.ButtonPressedResetter;
begin
  sbDashboard.IsPressed := False;
  sbPatients.IsPressed := False;
  sbAppointments.IsPressed := False;
end;

{ New Appointment }
procedure TfrmMain.fDashboardbtnNewAppointmentClick(Sender: TObject);
begin
  HideFrames;

  // Switch to appointments tab
  tcController.TabIndex := 2;

  // Show appointments frames
  fAppointments.Visible := True;

  // Button pressed
  ButtonPressedResetter;  // resetter
  sbAppointments.IsPressed := True;
end;

{ New Patient }
procedure TfrmMain.fDashboardbtnNewPatientClick(Sender: TObject);
begin
  HideFrames;

  // Switch to patients tab
  tcController.TabIndex := 1;

  // Show patients frame
  fPatients.Visible := True;

  // Button pressed
  ButtonPressedResetter;  // resetter
  sbPatients.IsPressed := True;
end;

procedure TfrmMain.fDashboardsbListClick(Sender: TObject);
begin
  fDashboard.sbListClick(Sender);

  // Dashboard card resize
  fDashboard.CardsResize;

  // Grid Responsiveness
  fDashboard.GridContentsResponsive;
end;

{ Float animation }
procedure TfrmMain.FloatAnimation1Finish(Sender: TObject);
begin
  FloatAnimation1.Enabled := False;
end;

{ Form Close }
procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;

  TDialogService.MessageDialog(
    'Are you sure you want to close the application?',
    TMsgDlgType.mtWarning,                  // warning icon
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],    // Yes + No buttons
    TMsgDlgBtn.mbNo,                        // Default button is No
    0,                                      // Help context
    procedure(const AResult: TModalResult)
    begin
      if AResult = mrYes then
      begin
        QueryHandler;
        Application.Terminate;
      end;
      // If No pressed, do nothing
    end
  );
end;

{ Form Create }
procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // Form reader
  dm.FormReader := 'Main';

  // Assign default tab index
  sbDashboardClick(Sender);

  // Default tab index
  tcController.TabIndex := 0;

  // Open Records for the Dashboard cards
  Dashboard;

  // Grid Responsiveness
  fDashboard.GridContentsResponsive;

  // Table style for Dashboard
  if dm.qAppointments.IsEmpty then // no records
    fDashboard.gTodaysAppointment.StyleLookup := 'gPatientStyle'
  else
    fDashboard.gTodaysAppointment.StyleLookup := ''; // with records

  // Table style for Patients
  if dm.qPatients.IsEmpty then
    fPatients.gPatients.StyleLookup := 'gPatientStyle'
  else
    fPatients.gPatients.StyleLookup := '';

  // Table style for Appointments
  if dm.qAppointments.IsEmpty then
    fAppointments.gAppointment.StyleLookup := 'gPatientStyle'
  else
    fAppointments.gAppointment.StyleLookup := '';

  // Table style for Users
  if dm.qUsers.IsEmpty then
    fUsers.gUsers.StyleLookup := 'gPatientStyle'
  else
    fUsers.gUsers.StyleLookup := '';

  // Date formatted display
  fDashboard.fToolbar.lDate.Text :=  FormatDateTime('dddd, mmmm d, yyyy', Now);
  fPatients.fToolbar.lDate.Text :=  FormatDateTime('dddd, mmmm d, yyyy', Now);
  fAppointments.fToolbar.lDate.Text :=  FormatDateTime('dddd, mmmm d, yyyy', Now);
  fUsers.fToolbar.lDate.Text := FormatDateTime('dddd, mmmm d, yyyy', Now);
  fUserProfile.fToolbar.lDate.Text := FormatDateTime('dddd, mmmm d, yyyy', Now);

  Self.Caption := 'Dental System';
end;

{ Form Resized }
procedure TfrmMain.FormResize(Sender: TObject);
begin
  // Form Caption
  {$IFDEF DEBUG}
  Self.Caption := 'Dental System | '+ 'Height: ' +
  Self.ClientHeight.ToString + ', ' + 'Width: ' + Self.ClientWidth.ToString + ' Card width: '
  + fDashboard.glytCards.Width.ToString + ' Card height: ' + fDashboard.glytCards.Height.ToString;
  {$ENDIF}

  // Fixed form dimension
  if Self.ClientHeight < 505 then
  begin
    Self.Height := 505;
  end;

  if Self.ClientWidth < 835 then
  begin
    Self.Width := 835;
  end;

  // Records layout
  if Self.ClientWidth > 1900 then
  begin
    fDashboard.lytRecords.Align := TAlignLayout.Client;
  end
  else
  begin
    fDashboard.lytRecords.Align := TAlignLayout.Top;
    fDashboard.lytRecords.Height := 390;
  end;

  // Dashboard cards resize
  fDashboard.CardsResize;
end;

{ Show Form }
procedure TfrmMain.FormShow(Sender: TObject);
begin
  // Default Show sidebar
  mvSidebar.ShowMaster;
  mvSidebar.NavigationPaneOptions.CollapsedWidth := 50;
  fDashboard.FrameResized(Sender);

  // Set the profile display in toolbar
  fDashboard.fToolbar.ProfileSetter;
  fPatients.fToolbar.ProfileSetter;
  fAppointments.fToolbar.ProfileSetter;
  fUsers.fToolbar.ProfileSetter;
  fUserProfile.fToolbar.ProfileSetter;
end;

{ Save/Update Patient Modal }
procedure TfrmMain.fPatientModalbtnSavePatientClick(Sender: TObject);
begin
  fPatientModal.btnSavePatientClick(Sender);
end;

{ Timer }
procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False; // Stop the timer
  lytPopUpBottom.Visible := False; // Hide the snackbar
end;

{ Pop up Message }
procedure TfrmMain.RecordMessage(const AEntity, ADetail: string);
begin
  // pop up function
  rPopUp.Height := 0;
  lytPopUpBottom.Visible := True;
  FloatAnimation1.Enabled := True;
  Timer1.Enabled := True; // Start the 5-second countdown

  // Message of the pop up and color setting
  case Self.Tag of
    0:  // Patient create
      begin
        lbPopUp.Words.Items[0].FontColor := TAlphaColorRec.Black;
        lbPopUp.Words.Items[1].FontColor := TAlphaColorRec.Dimgray;
        lbPopUp.Words.Items[0].Text := AEntity + ' information saved';
        lbPopUp.Words.Items[1].Text := 'The ' + ADetail +
          ' details have been saved successfully.';
        rPopUp.Fill.Color := TAlphaColorRec.White;
        // Icon set to green success
        gPopUp.ImageIndex := 8;
      end;
    1:  // Patient update
      begin
        lbPopUp.Words.Items[0].FontColor := TAlphaColorRec.Black;
        lbPopUp.Words.Items[1].FontColor := TAlphaColorRec.Dimgray;
        lbPopUp.Words.Items[0].Text := AEntity + ' information updated';
        lbPopUp.Words.Items[1].Text := 'The ' + ADetail +
          ' details have been updated successfully.';
        rPopUp.Fill.Color := TAlphaColorRec.White;
        // Icon set to yellow success
        gPopUp.ImageIndex := 32;
      end;
    2:  // Patient delete
      begin
        lbPopUp.Words.Items[0].FontColor := TAlphaColorRec.White;
        lbPopUp.Words.Items[1].FontColor := TAlphaColorRec.Gray;
        lbPopUp.Words.Items[0].Text := AEntity + ' deleted successfully';
        lbPopUp.Words.Items[1].Text := ADetail +
          ' has been removed from patient records.';
        rPopUp.Fill.Color := TAlphaColorRec.White;
        // Icon set to red success
        gPopUp.ImageIndex := 33;
      end;
      3:  // Appointment create
      begin
        lbPopUp.Words.Items[0].FontColor := TAlphaColorRec.Black;
        lbPopUp.Words.Items[1].FontColor := TAlphaColorRec.Dimgray;
        lbPopUp.Words.Items[0].Text := AEntity + ' created';
        lbPopUp.Words.Items[1].Text := 'New ' + ADetail +
          ' has been scheduled successfully.';
        rPopUp.Fill.Color := TAlphaColorRec.White;
        // Icon set to green success
        gPopUp.ImageIndex := 8;
      end;
      4:  // Appointment update
      begin
        lbPopUp.Words.Items[0].FontColor := TAlphaColorRec.Black;
        lbPopUp.Words.Items[1].FontColor := TAlphaColorRec.Dimgray;
        lbPopUp.Words.Items[0].Text := AEntity + ' updated';
        lbPopUp.Words.Items[1].Text := 'The ' + ADetail +
          ' has been updated successfully.';
        rPopUp.Fill.Color := TAlphaColorRec.White;
        // Icon set to yellow success
        gPopUp.ImageIndex := 32;
      end;
      5:  // Appointment delete
      begin
        lbPopUp.Words.Items[0].FontColor := TAlphaColorRec.Black;
        lbPopUp.Words.Items[1].FontColor := TAlphaColorRec.Dimgray;
        lbPopUp.Words.Items[0].Text := AEntity + ' deleted';
        lbPopUp.Words.Items[1].Text := 'The ' + ADetail +
          ' has been deleted successfully.';
        rPopUp.Fill.Color := TAlphaColorRec.White;
        // Icon set to red success
        gPopUp.ImageIndex := 33;
      end;
      6:  // User create
      begin
        lbPopUp.Words.Items[0].FontColor := TAlphaColorRec.Black;
        lbPopUp.Words.Items[1].FontColor := TAlphaColorRec.Dimgray;
        lbPopUp.Words.Items[0].Text := AEntity + ' added successfully';
        lbPopUp.Words.Items[1].Text := 'Your ' + ADetail +
          ' has been added to the system.';
        rPopUp.Fill.Color := TAlphaColorRec.White;
        // Icon set to yellow success
        gPopUp.ImageIndex := 32;
      end;
      7:  // User Update
      begin
        lbPopUp.Words.Items[0].FontColor := TAlphaColorRec.Black;
        lbPopUp.Words.Items[1].FontColor := TAlphaColorRec.Black;
        lbPopUp.Words.Items[0].Text := AEntity + ' updated successfully';
        lbPopUp.Words.Items[1].Text := ADetail +
          ' information has been updated.';
        rPopUp.Fill.Color := TAlphaColorRec.White;
        // Icon set to yellow success
        gPopUp.ImageIndex := 32;
      end;
      8:  // User delete
      begin
        lbPopUp.Words.Items[0].FontColor := TAlphaColorRec.White;
        lbPopUp.Words.Items[1].FontColor := TAlphaColorRec.Dimgray;
        lbPopUp.Words.Items[0].Text := AEntity + ' deleted successfully';
        lbPopUp.Words.Items[1].Text := ADetail +
          ' has been removed from the system.';
        rPopUp.Fill.Color := TAlphaColorRec.White;
        // Icon set to yellow success
        gPopUp.ImageIndex := 32;
      end;
      9:  // User Profile Update
      begin
        lbPopUp.Words.Items[0].FontColor := TAlphaColorRec.Black;
        lbPopUp.Words.Items[1].FontColor := TAlphaColorRec.Dimgray;
        lbPopUp.Words.Items[0].Text := AEntity + ' updated';
        lbPopUp.Words.Items[1].Text := 'Your ' + ADetail +
          ' information has been successfully updated.';
        rPopUp.Fill.Color := TAlphaColorRec.White;
        // Icon set to yellow success
        gPopUp.ImageIndex := 32;
      end;
      10:  // Update password
      begin
        lbPopUp.Words.Items[0].FontColor := TAlphaColorRec.Black;
        lbPopUp.Words.Items[1].FontColor := TAlphaColorRec.Dimgray;
        lbPopUp.Words.Items[0].Text := AEntity + ' updated';
        lbPopUp.Words.Items[1].Text := 'Your ' + ADetail +
          ' has been changed successfully.';
        rPopUp.Fill.Color := TAlphaColorRec.White;
        // Icon set to yellow success
        gPopUp.ImageIndex := 32;
      end;
      11:  // Update profile
      begin
        lbPopUp.Words.Items[0].FontColor := TAlphaColorRec.Black;
        lbPopUp.Words.Items[1].FontColor := TAlphaColorRec.Dimgray;
        lbPopUp.Words.Items[0].Text := AEntity + ' updated';
        lbPopUp.Words.Items[1].Text := 'Your ' + ADetail +
          ' photo has been updated successfully.';
        rPopUp.Fill.Color := TAlphaColorRec.White;
        // Icon set to yellow success
        gPopUp.ImageIndex := 32;
      end;
      12:  // Update profile
      begin
        lbPopUp.Words.Items[0].FontColor := TAlphaColorRec.Black;
        lbPopUp.Words.Items[1].FontColor := TAlphaColorRec.Dimgray;
        lbPopUp.Words.Items[0].Text := AEntity + ' removed';
        lbPopUp.Words.Items[1].Text := 'Your ' + ADetail +
          ' photo has been removed successfully.';
        rPopUp.Fill.Color := TAlphaColorRec.White;
        // Icon set to yellow success
        gPopUp.ImageIndex := 32;
      end;
      13:  // Update user password
      begin
        lbPopUp.Words.Items[0].FontColor := TAlphaColorRec.Black;
        lbPopUp.Words.Items[1].FontColor := TAlphaColorRec.Dimgray;
        lbPopUp.Words.Items[0].Text := AEntity + ' updated';
        lbPopUp.Words.Items[1].Text := ADetail +
          ' password has been changed successfully.';
        rPopUp.Fill.Color := TAlphaColorRec.White;
        // Icon set to yellow success
        gPopUp.ImageIndex := 32;
      end;
  end;
end;

{ Add new patient }
procedure TfrmMain.fPatientsbtnAddNewPatientClick(Sender: TObject);
begin
  fPatients.btnAddNewPatientClick(Sender);
end;

{ Add New User }
procedure TfrmMain.fUsers1btnAddNewUserClick(Sender: TObject);
begin
  // User Modal visibility
  fUserModal.Visible := True;
end;

{ Sidebar Resized }
procedure TfrmMain.mvSidebarResize(Sender: TObject);
begin
  // Sidebar adjustment
  if mvSidebar.Width < 51 then
  begin
    lbMainMenu.Visible := false;
    lDivider.Visible := true;
  end
  else
  begin
    lbMainMenu.Visible := true;
    lDivider.Visible := false;
  end;

  // Adjust layout holder
  lytSidebar.Width := mvSidebar.Width;

  {$IFDEF DEBUG}
  // Form caption
  Self.Caption := 'Dental System | '+ 'Height: ' +
  Self.ClientHeight.ToString + ', ' + 'Width: ' + Self.ClientWidth.ToString + ' Card width: '
  + fDashboard.glytCards.Width.ToString + ' Card height: ' + fDashboard.glytCards.Height.ToString;
  {$ENDIF}
end;

{ Button Press Resetter }
procedure TfrmMain.ButtonPressedReset;
begin
  sbAppointments.IsPressed := False;
  sbDashboard.IsPressed := False;
  sbPatients.IsPressed := False;
  sbUsers.IsPressed := False;
end;

{ Appointments tab }
procedure TfrmMain.sbAppointmentsClick(Sender: TObject);
begin
  // Hide frames
  HideFrames;

  // Reset Button
  ButtonPressedReset;
  sbAppointments.IsPressed := True;

  // Switch tab index
  tcController.TabIndex := 2;
  fAppointments.Visible := True;
  fAppointments.ScrollBox1.ViewportPosition := PointF(0,0); // reset scrollbox

  // Set today's appointment
  frmMain.fAppointments.cbDayClick(Sender);
  frmMain.fAppointments.cbDay.IsPressed := True;

  // Grid responsive
  fAppointments.GridContentsResponsive;
end;

{ Dashboard tab }
procedure TfrmMain.sbDashboardClick(Sender: TObject);
begin
  // Hide frames
  HideFrames;

  // Reset Button
  ButtonPressedReset;
  sbDashboard.IsPressed := True;

  // Dashboard card resize
  fDashboard.CardsResize;

  // Switch tab index
  tcController.TabIndex := 0;
  fDashboard.Visible := True;
  fDashboard.ScrollBox1.ViewportPosition := PointF(0,0); // reset scrollbox

  // Grid Responsiveness
  fDashboard.GridContentsResponsive;

  // Form Caption
  {$IFDEF DEBUG}
  Self.Caption := 'Dental System | '+ 'Height: ' +
  Self.ClientHeight.ToString + ', ' + 'Width: ' + Self.ClientWidth.ToString + ' Card width: '
  + fDashboard.Width.ToString + ' Card height: ' + fDashboard.Height.ToString;
  {$ENDIF}
end;

{ Patients tab }
procedure TfrmMain.sbPatientsClick(Sender: TObject);
begin
  // Hide frames
  HideFrames;

  // Reset Button
  ButtonPressedReset;
  sbPatients.IsPressed := True;

  // Switch tab index
  tcController.TabIndex := 1;
  fPatients.Visible := True;
  fPatients.ScrollBox1.ViewportPosition := PointF(0,0); // reset scrollbox

  // Grid responsive
  fPatients.GridContentsResponsive;
end;

{ Users tab }
procedure TfrmMain.sbUsersClick(Sender: TObject);
begin
  // Hide frames
  HideFrames;

  // Reset Button
  ButtonPressedReset;
  sbUsers.IsPressed := True;

  // Switch tab index
  tcController.TabIndex := 3;
  fUsers.Visible := True;
  fUsers.ScrollBox1.ViewportPosition := PointF(0, 0); // reset scrollbox

  // Grid responsive
  fUsers.GridContentsResponsive;
end;

{ Query Management }
procedure TfrmMain.QueryHandler;
begin
  dm.qPatients.Close;
  dm.qAppointments.Close;
  dm.qUsers.Close;
  dm.qTodaysAppointment.Close;
end;

{ Dashboard tab }
procedure TfrmMain.Dashboard;
var
  totalPatients: Integer;
  todaysAppointments: Integer;
  newAppointments: Integer;
  completed: Integer;
  todayStr: string;
begin
  // Assign value to total patients variable
  if dm.qTemp.Active then
    dm.qTemp.Close;

  dm.qTemp.SQL.Text :=
    'SELECT COUNT(id) AS Total_patients ' +
    'FROM patients';
  dm.qTemp.Open;
  totalPatients := dm.qTemp.FieldByName('Total_Patients').AsInteger;
  fDashboard.lbTotalPatientsC.Text := totalPatients.ToString;

  // Assign value to today's appointment
  // Format today's date as YYYY-MM-DD (adjust to match your database format)
  todayStr := FormatDateTime('yyyy-mm-dd', Date);

  if (dm.qTemp.Active) OR (dm.qTodaysAppointment.Active) then
  begin
    dm.qTemp.Close;
    dm.qTodaysAppointment.Close;
  end;

  dm.qTemp.SQL.Text :=
    'SELECT COUNT(status) AS Todays_Appointments ' +
    'FROM appointments ' +
    'WHERE (status IN (''New'', ''Ongoing'')) ' +
    '  AND (DATE(date_appointment) = :today)';  // Use a parameter for today's date

  dm.qTodaysAppointment.SQL.Text :=
    'SELECT id, patient, appointment_title, date_appointment, status ' +
    'FROM appointments ' +
    'WHERE (status IN (''New'', ''Ongoing'')) ' +
    '  AND (DATE(date_appointment) = :today)';  // Use a parameter for today's date

  // Assign parameter value
  dm.qTemp.ParamByName('today').AsString := todayStr;
  dm.qTodaysAppointment.ParamByName('today').AsString := todayStr;
  dm.qTemp.Open;
  dm.qTodaysAppointment.Open;

  // Read the field value
  todaysAppointments := dm.qTemp.FieldByName('Todays_Appointments').AsInteger;
  fDashboard.lbTodaysAppointmentC.Text := todaysAppointments.ToString;

  // Records checker for todays appointment
  if dm.qTodaysAppointment.IsEmpty then
  begin
    frmMain.fDashboard.lNoRecords.Visible := True;
    frmMain.fDashboard.rNoRecords.Visible := True;
  end
  else
  begin
    frmMain.fDashboard.lNoRecords.Visible :=  False;
    frmMain.fDashboard.rNoRecords.Visible := False;
  end;

  // Assign value to new appointments
  if dm.qTemp.Active then
    dm.qTemp.Close;

  dm.qTemp.SQL.Text :=
    'SELECT COUNT(status) as New_Appointments ' +
    'FROM appointments ' +
    'WHERE status = ''New''';
  dm.qTemp.Open;
  newAppointments := dm.qTemp.FieldByName('New_Appointments').AsInteger;
  fDashboard.lbNewAppointmentsC.Text := newAppointments.ToString;

  // Assign value to completed appointments
  if dm.qTemp.Active then
    dm.qTemp.Close;

  dm.qTemp.SQL.Text :=
    'SELECT COUNT(status) as Completed_Appointments ' +
    'FROM appointments ' +
    'WHERE status = ''Completed''';
  dm.qTemp.Open;
  completed := dm.qTemp.FieldByName('Completed_Appointments').AsInteger;
  fDashboard.lbCompletedC.Text := completed.ToString;
end;

{ Tab controller change }
procedure TfrmMain.tcControllerChange(Sender: TObject);
begin
  // Deactivate queries for optimization
  QueryHandler;

  // Change database connection according to the selected tab
  case tcController.TabIndex of
    0: Dashboard;
    1: fPatients.PatientRecords;
    2: dm.qAppointments.Open;
    3: dm.qUsers.Open;
  end;
end;

end.
