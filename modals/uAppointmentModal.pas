unit uAppointmentModal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.Skia, FMX.Skia, FMX.ListBox, FMX.Effects, FMX.Objects, FMX.Edit,
  FMX.ImgList, FMX.Controls.Presentation, FMX.Layouts, FMX.DateTimeCtrls,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.ComboEdit, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope;

type
  TfAppointmentModal = class(TFrame)
    lytContentH: TLayout;
    rBackground: TRectangle;
    rModalInfo: TRectangle;
    ScrollBox1: TScrollBox;
    lytTitle: TLayout;
    lbTitle: TLabel;
    btnClose: TSpeedButton;
    lytHolder: TLayout;
    lytDetails1: TLayout;
    lPatient: TLabel;
    crPatient: TCalloutRectangle;
    gPatient: TGlyph;
    lPatientW: TLabel;
    ShadowEffect1: TShadowEffect;
    lytDetails2: TLayout;
    lAppointmentTitle: TLabel;
    eAppointmentTitle: TEdit;
    crAppointmentTitle: TCalloutRectangle;
    gAppointmentTitle: TGlyph;
    lAppointmentTitleW: TLabel;
    ShadowEffect2: TShadowEffect;
    lytDetails3: TLayout;
    lytStatus: TLayout;
    lStatus: TLabel;
    cbStatus: TComboBox;
    lytDate: TLayout;
    lDate: TLabel;
    deDate: TDateEdit;
    lytDetails4: TLayout;
    lytEndTime: TLayout;
    lEndTime: TLabel;
    lytStartTime: TLayout;
    lStartTime: TLabel;
    teStartTime: TTimeEdit;
    teEndTime: TTimeEdit;
    lytDetails5: TLayout;
    lNotes: TLabel;
    mNotes: TMemo;
    lPickDate: TLabel;
    lytButtonH: TLayout;
    btnCreateAppointment: TCornerButton;
    btnCancel: TCornerButton;
    cbPatient: TComboEdit;
    crDate: TCalloutRectangle;
    gDate: TGlyph;
    lDateW: TLabel;
    ShadowEffect3: TShadowEffect;
    procedure btnCloseClick(Sender: TObject);
    procedure FrameResized(Sender: TObject);
    procedure lytDetails3Resized(Sender: TObject);
    procedure lytDetails4Resized(Sender: TObject);
    procedure mNotesClick(Sender: TObject);
    procedure mNotesExit(Sender: TObject);
    procedure btnCreateAppointmentClick(Sender: TObject);
    procedure cbPatientEnter(Sender: TObject);
    procedure deDateCheckChanged(Sender: TObject);
    procedure deDateChange(Sender: TObject);
    procedure cbPatientChangeTracking(Sender: TObject);
    procedure eAppointmentTitleChangeTracking(Sender: TObject);
  private
    { Private declarations }
  public
    MemoTrackingReset: String;
    RecordStatus: String;
    procedure ClearItems;
    procedure FieldComponentsResponsive;
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uMain, uDm;

{ Clear Items }
procedure TfAppointmentModal.ClearItems;
begin
  // Reset Date
  deDate.DateFormatKind := TDTFormatKind.Short;
  deDate.TodayDefault := True;
  lPickDate.Visible := True;
  deDate.StyledSettings := deDate.StyledSettings - [TStyledSetting.FontColor];

  // Reset Status
  cbStatus.ItemIndex := 0;

  // Reset Patient
  cbPatient.Items.Clear;
  cbPatient.Items.Add('Select patient...');
  cbPatient.ItemIndex := 0;
  cbPatient.Enabled := True;

  // Reset Appointment Title
  eAppointmentTitle.Text := '';

  // Reset Notes
  MemoTrackingReset := 'Empty';
  mNotes.Text := 'Add any relevant notes about this appointment';
end;

{ Create/Update Appointment }
procedure TfAppointmentModal.btnCreateAppointmentClick(Sender: TObject);
var
  HasError: Boolean;
begin
  HasError:= False;

  // Date validation
  if lPickDate.Visible then
  begin
    crDate.Visible := True;
    HasError := True;
  end
  else
    crDate.Visible := False;

  // Patient validation
  if cbPatient.Text = 'Select patient...' then
  begin
    crPatient.Visible := True;
    HasError := True;
  end
  else
    crPatient.Visible := False;

  // Appointment Title validation
  if eAppointmentTitle.Text = '' then
  begin
    crAppointmentTitle.Visible := True;
    HasError := True;
  end
  else
    crAppointmentTitle.Visible := False;

  // Stop if any error is found
  if HasError = True then
  begin
    Exit;
  end;

  // Handle record state
  if dm.RecordStatus = 'Add' then
    dm.qAppointments.Append
  else
    dm.qAppointments.Edit;

  // Fields to save
  dm.qAppointments.FieldByName('date_appointment').AsDateTime := deDate.Date;

  deDate.DateFormatKind := TDTFormatKind.Long;  // Set date format to long
  dm.qAppointments.FieldByName('date_long').AsString := deDate.Text;

  dm.qAppointments.FieldByName('status').AsString := cbStatus.Text;
  dm.qAppointments.FieldByName('patient').AsString := cbPatient.Text;
  dm.qAppointments.FieldByName('appointment_title').AsString := eAppointmentTitle.Text;
  dm.qAppointments.FieldByName('start_time').AsString := teStartTime.Text;
  dm.qAppointments.FieldByName('end_time').AsString := teEndTime.Text;

  // Set notes to empty
  if mNotes.Text = 'Add any relevant notes about this appointment' then
    mNotes.Text := '';
  dm.qAppointments.FieldByName('notes').AsString := mNotes.Text;


  dm.qAppointments.FieldByName('created_at').AsDateTime := Now;

  dm.qAppointments.Post;
  dm.qAppointments.Refresh;
  dm.qPatientSelection.Close;

  ClearItems; // clear fields

  // Set record pop up message
  if dm.RecordStatus = 'Add' then
    frmMain.Tag := 3
  else
    frmMain.Tag := 4;

  frmMain.RecordMessage('Appointment', 'appointment');

  // Hide patient modal
  Self.Visible := False;
end;

{ Patient On Change Tracking }
procedure TfAppointmentModal.cbPatientChangeTracking(Sender: TObject);
begin
  crPatient.Visible := False;
end;

{ Patient On Enter }
procedure TfAppointmentModal.cbPatientEnter(Sender: TObject);
begin
  cbPatient.Items.Clear;
  cbPatient.Items.Add('Select patient...');

  dm.qPatientSelection.Close;
  dm.qPatientSelection.Open;

  while not dm.qPatientSelection.Eof do
  begin
    cbPatient.Items.Add(dm.qPatientSelection.FieldByName('fullname').AsString);
    dm.qPatientSelection.Next;
  end;
end;

{ On Change picker Date }
procedure TfAppointmentModal.deDateChange(Sender: TObject);
begin
  // Hide Date pick label
  lPickDate.Visible := False;

  // Show date text
  deDate.StyledSettings := [TStyledSetting.FontColor];
  deDate.TodayDefault := False;

  crDate.Visible := False;
end;

{ On Check change }
procedure TfAppointmentModal.deDateCheckChanged(Sender: TObject);
begin
  if deDate.Date = Now then
  begin
    // Show date text
    deDate.StyledSettings := [TStyledSetting.FontColor];
    deDate.TextSettings.FontColor := TAlphaColorRec.Black;

    // Hide Date pick label
    lPickDate.Visible := False;
  end;
end;

{ Appointment Title On Change Tracking }
procedure TfAppointmentModal.eAppointmentTitleChangeTracking(Sender: TObject);
begin
  crAppointmentTitle.Visible := False;
end;

{ Layout Responsiveness adjuster }
procedure TfAppointmentModal.FieldComponentsResponsive;
begin
  lytDate.Width := Trunc(lytDetails1.Width / 2) - 10; // -10 to account for spacing
  lytStatus.Width := Trunc(lytDetails1.Width / 2) - 10;
  lytStartTime.Width := Trunc(lytDetails2.Width / 2) - 10;
  lytEndTime.Width := Trunc(lytDetails2.Width / 2) - 10;
end;

{ Modal Frame Resized }
procedure TfAppointmentModal.FrameResized(Sender: TObject);
begin
  FieldComponentsResponsive;

  // Modal content margins
  if (frmMain.ClientWidth >= 1920) then
  begin
    rModalInfo.Margins.Left := 700;
    rModalInfo.Margins.Right := 700;
    rModalInfo.Margins.Top := 150;
    rModalInfo.Margins.Bottom := 150;
  end
  else if (frmMain.ClientWidth >= 1366) then
  begin
    rModalInfo.Margins.Left := 490;
    rModalInfo.Margins.Right := 490;
    rModalInfo.Margins.Top := 75;
    rModalInfo.Margins.Bottom := 75;
  end
  else if (frmMain.ClientHeight <= 510) AND (frmMain.ClientWidth <= 860) then
  begin
    rModalInfo.Margins.Left := 220;
    rModalInfo.Margins.Right := 220;
    rModalInfo.Margins.Top := 50;
    rModalInfo.Margins.Bottom := 50;
  end;
end;

{ Responsive Details 3 }
procedure TfAppointmentModal.lytDetails3Resized(Sender: TObject);
begin
  FieldComponentsResponsive;
end;

{ Responsive Details 4 }
procedure TfAppointmentModal.lytDetails4Resized(Sender: TObject);
begin
  FieldComponentsResponsive;
end;

{ On Click Notes }
procedure TfAppointmentModal.mNotesClick(Sender: TObject);
begin
  if mNotes.Text = 'Add any relevant notes about this appointment' then
  begin
    MemoTrackingReset := 'Clicked';
    mNotes.Text := '';
  end;
end;

{ On Exit Notes }
procedure TfAppointmentModal.mNotesExit(Sender: TObject);
begin
  if (MemoTrackingReset = 'Clicked') AND (mNotes.Text.Trim.IsEmpty) then
  begin
    MemoTrackingReset := 'Empty';
  end;

  if (MemoTrackingReset = 'Empty') then
  begin
    mNotes.Text := 'Add any relevant notes about this appointment';
  end;
end;

{ Close Button }
procedure TfAppointmentModal.btnCloseClick(Sender: TObject);
begin
  Self.Visible := False;

  // Close query
  dm.qPatientSelection.Close;
end;

end.
