unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.MultiView, FMX.TabControl, FMX.StdCtrls,
  FMX.Objects, uDashboard, FMX.ImgList, uPatients, uAppointments, uPatientModal,
  uUsers, uUserProfile, uUserModal, System.Skia, FMX.Skia, FMX.Ani;

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
    fPatients: TfPatients;
    tiAppointments: TTabItem;
    fAppointments: TfAppointments;
    fPatientModal: TfPatientModal;
    lDivider: TLine;
    lbMainMenu: TLabel;
    sbUsers: TSpeedButton;
    tiUsers: TTabItem;
    tiUserProfile: TTabItem;
    fUserProfile: TfUserProfile;
    fUserModal: TfUserModal;
    lytPopUpBottom: TLayout;
    lytPopUpMessage: TLayout;
    rPopUp: TRectangle;
    FloatAnimation1: TFloatAnimation;
    gPopUp: TGlyph;
    Timer1: TTimer;
    lbPopUp: TSkLabel;
    fUsers: TfUsers;
    procedure FormCreate(Sender: TObject);
    procedure mvSidebarResize(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure tcControllerChange(Sender: TObject);
    procedure sbPatientsClick(Sender: TObject);
    procedure sbDashboardClick(Sender: TObject);
    procedure sbAppointmentsClick(Sender: TObject);
    procedure fPatientsbtnAddNewPatientClick(Sender: TObject);
    procedure fDashboardbtnNewPatientClick(Sender: TObject);
    procedure fDashboardbtnNewAppointmentClick(Sender: TObject);
    procedure fUsers1btnAddNewUserClick(Sender: TObject);
    procedure sbUsersClick(Sender: TObject);
    procedure fPatientModalbtnSavePatientClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FloatAnimation1Finish(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    procedure HideFrames;
    procedure ButtonPressedResetter;
    procedure RecordMessage(const AEntity: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses uDm;
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

{ Float animation }
procedure TfrmMain.FloatAnimation1Finish(Sender: TObject);
begin
  FloatAnimation1.Enabled := False;
end;

{ Form create }
procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // Default tab index
  tcController.TabIndex := 0;

  // Default Show sidebar
  mvSidebar.ShowMaster;
  mvSidebar.NavigationPaneOptions.CollapsedWidth := 50;

  fDashboard.FrameResize(Sender);
  fDashboard.CardsResize;

  // Patient Modal content responsive
  fPatientModal.EditComponentsResponsive;
end;

{ Form Resized }
procedure TfrmMain.FormResize(Sender: TObject);
begin
  // Form Caption
  Self.Caption := 'Dental System | '+ 'Height: ' +
  Self.ClientHeight.ToString + ', ' + 'Width: ' + Self.ClientWidth.ToString + ' Card width: '
  + fDashboard.glytCards.Width.ToString + ' Card height: ' + fDashboard.glytCards.Height.ToString;

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
procedure TfrmMain.RecordMessage(const AEntity: string);
begin
  // pop up function
  rPopUp.Height := 0;
  lytPopUpBottom.Visible := True;
  FloatAnimation1.Enabled := True;
  Timer1.Enabled := True; // Start the 5-second countdown

  // Message of the pop up and color setting
  case Self.Tag of
    0:
      begin
        lbPopUp.TextSettings.FontColor := TAlphaColors.White;
        lbPopUp.Text := 'Successfully added the ' + AEntity + '!';
        rPopUp.Fill.Color := TAlphaColorRec.Green;
      end;
    1:
      begin
        lbPopUp.TextSettings.FontColor := TAlphaColors.Black;
        lbPopUp.Text := 'Successfully updated the ' + AEntity + '!';
        rPopUp.Fill.Color := TAlphaColorRec.Yellow;
      end;
    2:
      begin
        lbPopUp.TextSettings.FontColor := TAlphaColors.White;
        lbPopUp.Text := 'Successfully deleted the ' + AEntity + '!';
        rPopUp.Fill.Color := TAlphaColorRec.Red;
      end;
  end;
end;

{ Add new patient }
procedure TfrmMain.fPatientsbtnAddNewPatientClick(Sender: TObject);
begin
  // Set the record status to Add
  fPatientModal.RecordStatus := 'Add';

  // Set title
  fPatientModal.lbTitle.Text := 'Add New Patient';

  // Set button text
  fPatientModal.btnSavePatient.Text := 'Save Patient';

  // Clear image
  fPatientModal.imgProfilePhoto.Bitmap := nil;

  // Hide Image Frame
  fPatientModal.rImageFrame.Visible := False;

  // Reset scrollbox
  fPatientModal.ScrollBox1.ViewportPosition := PointF(0, 0);

  // Patient Modal visibility
  fPatientModal.Visible := True;
  fPatientModal.gIcon.Visible := True;  // Show user icon
  fPatientModal.cbGender.ItemIndex := 0;
  fPatientModal.ScrollBox1.ViewportPosition := PointF(0, 0);  // reset scrollbox
  fPatientModal.Tag := 0;

  // Gender Display text value
  fPatientModal.lGenderText.Text := fPatientModal.cbGender.Text;

  // Profile Icon
  fPatientModal.gIcon.ImageIndex := 10;
  fPatientModal.gIcon.Visible := True;
  fPatientModal.lNameH.Visible := False;
  fPatientModal.lNameH.Text := '';
  fPatientModal.eFullName.Text := '';

  // Reset Age
  fPatientModal.lAgeCounter.Text := 'Age: 0 years';

  // Medical notes
  fPatientModal.mMedicalNotes.Text := 'Enter any relevant medical history, allergies, or notes';
  fPatientModal.MemoTrackingReset := 'Empty';
  fPatientModal.lTag.Text := 'Tag Number : ' + fPatientModal.MemoTrackingReset;
  fPatientModal.deDateOfBirth.TextSettings.FontColor := TAlphaColors.White;
  fPatientModal.lDateText.Visible := True;

  // Font color Style settings of date edit
  fPatientModal.deDateOfBirth.StyledSettings :=
  fPatientModal.deDateOfBirth.StyledSettings - [TStyledSetting.FontColor];
end;

{ Add New User }
procedure TfrmMain.fUsers1btnAddNewUserClick(Sender: TObject);
begin
  // User Modal visibility
  fUserModal.Visible := True;

  // Role & Status text value
  fUserModal.lRoleInput.Text := fUserModal.cbRole.Text;
  fUserModal.lStatusInput.Text := fUserModal.cbStatus.Text;
end;

{ Sidebar Resized }
procedure TfrmMain.mvSidebarResize(Sender: TObject);
begin
  // Date formatted display
  fDashboard.lDate.Text :=  FormatDateTime('dddd, mmmm d, yyyy', Now);
  fPatients.lDate.Text :=  FormatDateTime('dddd, mmmm d, yyyy', Now);
  fAppointments.lDate.Text :=  FormatDateTime('dddd, mmmm d, yyyy', Now);
  fUsers.lDate.Text := FormatDateTime('dddd, mmmm d, yyyy', Now);

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

  fDashboard.CardsResize;

  // Form caption
  Self.Caption := 'Dental System | '+ 'Height: ' +
  Self.ClientHeight.ToString + ', ' + 'Width: ' + Self.ClientWidth.ToString + ' Card width: '
  + fDashboard.glytCards.Width.ToString + ' Card height: ' + fDashboard.glytCards.Height.ToString;
end;

{ Appointments tab }
procedure TfrmMain.sbAppointmentsClick(Sender: TObject);
begin
  // Hide frames
  HideFrames;

  // Switch tab index
  tcController.TabIndex := 2;
  fAppointments.Visible := True;
end;

{ Dashboard tab }
procedure TfrmMain.sbDashboardClick(Sender: TObject);
begin
  // Hide frames
  HideFrames;

  // Dashboard card resize
  fDashboard.CardsResize;

  // Switch tab index
  tcController.TabIndex := 0;
  fDashboard.Visible := True;
  fDashboard.ScrollBox1.ViewportPosition := PointF(0,0); // reset scrollbox

  Self.Caption := 'Dental System | '+ 'Height: ' +
  Self.ClientHeight.ToString + ', ' + 'Width: ' + Self.ClientWidth.ToString + ' Card width: '
  + fDashboard.Width.ToString + ' Card height: ' + fDashboard.Height.ToString;
end;

{ Patients tab }
procedure TfrmMain.sbPatientsClick(Sender: TObject);
begin
  // Hide frames
  HideFrames;

  // Switch tab index
  tcController.TabIndex := 1;
  fPatients.Visible := True;
  fPatients.ScrollBox1.ViewportPosition := PointF(0,0); // reset scrollbox
end;

{ Users tab }
procedure TfrmMain.sbUsersClick(Sender: TObject);
begin
  // Hide frames

  // Switch tab index
  tcController.TabIndex := 3;
  fUsers.Visible := True;
  fUsers.ScrollBox1.ViewportPosition := PointF(0, 0); // reset scrollbox
end;

procedure TfrmMain.tcControllerChange(Sender: TObject);
begin
  // Change database connection according to the selected tab
  case tcController.TabIndex of
    0:
  end;
end;

end.
