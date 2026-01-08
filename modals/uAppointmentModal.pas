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
    lPickDate: TLabel;
    lytButtonH: TLayout;
    btnCreateAppointment: TCornerButton;
    btnCancel: TCornerButton;
    cbPatient: TComboEdit;
    crDate: TCalloutRectangle;
    gDate: TGlyph;
    lDateW: TLabel;
    ShadowEffect3: TShadowEffect;
    btnDelete: TCornerButton;
    rDeleteBackground: TRectangle;
    rDeleteModal: TRectangle;
    lytDeleteInfo: TLayout;
    lytDeleteButtonH: TLayout;
    btnDeleteCancel: TCornerButton;
    btnDeleteAppointment: TCornerButton;
    lDeleteDesc: TLabel;
    lytDeleteTitle: TLayout;
    lDeleteTItle: TLabel;
    btnDeleteClose: TSpeedButton;
    mNotes: TMemo;
    GlowEffect1: TGlowEffect;
    procedure btnCloseClick(Sender: TObject);
    procedure FrameResized(Sender: TObject);
    procedure lytDetails3Resized(Sender: TObject);
    procedure lytDetails4Resized(Sender: TObject);
    procedure mNotesClick(Sender: TObject);
    procedure mNotesExit(Sender: TObject);
    procedure btnCreateAppointmentClick(Sender: TObject);
    procedure deDateCheckChanged(Sender: TObject);
    procedure eAppointmentTitleChangeTracking(Sender: TObject);
    procedure btnDeleteCancelClick(Sender: TObject);
    procedure btnDeleteCloseClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnDeleteAppointmentClick(Sender: TObject);
    procedure teStartTimeChange(Sender: TObject);
    procedure deDateEnter(Sender: TObject);
    procedure deDateExit(Sender: TObject);
    procedure deDateClosePicker(Sender: TObject);
    procedure deDateOpenPicker(Sender: TObject);
    procedure cbPatientEnter(Sender: TObject);
    procedure cbPatientTyping(Sender: TObject);
    procedure deDateChange(Sender: TObject);
    procedure cbPatientExit(Sender: TObject);
    procedure cbPatientClosePopup(Sender: TObject);
    procedure mNotesEnter(Sender: TObject);
  private
    { Private declarations }
  public
    MemoTrackingReset: String;
    RecordStatus: String;
    FAllPatients: TStringList;
    ceChecker: Boolean;
    procedure ClearItems;
    procedure FieldComponentsResponsive;
    procedure FormVisibility;
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uMain, uDm;

procedure TfAppointmentModal.FormVisibility;
begin
  if Self.Visible then
    FAllPatients := TStringList.Create
end;

{ Clear Items }
procedure TfAppointmentModal.ClearItems;
begin
  // Reset Date
  deDate.DateFormatKind := TDTFormatKind.Short;
  deDate.TodayDefault := True;
  lPickDate.Visible := True;
  lPickDate.FontColor := TAlphaColorRec.Gray;
  deDate.StyledSettings := deDate.StyledSettings - [TStyledSetting.FontColor];
  ceChecker := False;

  // Reset Status
  cbStatus.ItemIndex := 0;

  // Reset Patient
  cbPatient.Items.Clear;
  cbPatient.Items.Add('Select patient...');
  cbPatient.ItemIndex := 0;
  cbPatient.Enabled := True;
  cbPatient.FontColor := TAlphaColorRec.Gray;

  // Reset Appointment Title
  eAppointmentTitle.Text := '';

  // Reset Notes
  MemoTrackingReset := 'Empty';
  mNotes.Text := 'Add any relevant notes about this appointment';
  mNotes.FontColor := TAlphaColorRec.Gray;
end;

{ Create/Update Appointment }
procedure TfAppointmentModal.btnCreateAppointmentClick(Sender: TObject);
var
  HasError: Boolean;
begin
  HasError:= False;

  // Date validation
  if lPickDate.Text = 'Pick a date' then
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

  // Save formatted date as "mmm dd, yyyy" e.g. "Nov 13, 2025"
  dm.qAppointments.FieldByName('date_long').AsString := FormatDateTime('mmm dd, yyyy', deDate.Date);

  dm.qAppointments.FieldByName('status').AsString := cbStatus.Text;
  dm.qAppointments.FieldByName('patient').AsString := cbPatient.Text;
  dm.qAppointments.FieldByName('appointment_title').AsString := eAppointmentTitle.Text;
  dm.qAppointments.FieldByName('start_time').AsString := teStartTime.Text;
  dm.qAppointments.FieldByName('end_time').AsString := teEndTime.Text;

  // Set notes to empty
  if mNotes.Text = 'Add any relevant notes about this appointment' then
    mNotes.Text := '';
  dm.qAppointments.FieldByName('notes').AsString := mNotes.Text;

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

  // Records checker
  if frmMain.fAppointments.cbDay.IsPressed then
    frmMain.fAppointments.cbDayClick(Sender)
  else if frmMain.fAppointments.cbWeek.IsPressed then
    frmMain.fAppointments.cbWeekClick(Sender)
  else if frmMain.fAppointments.cbMonth.IsPressed then
    frmMain.fAppointments.cbMonthClick(Sender)
  else if frmMain.fAppointments.cbAllRecords.IsPressed then
    frmMain.fAppointments.cbAllRecordsClick(Sender);

  // Form visibility
  FormVisibility;
end;

{ Delete Button }
procedure TfAppointmentModal.btnDeleteClick(Sender: TObject);
begin
  rDeleteBackground.Visible := True;
end;

{ Delete Appointment Button }
procedure TfAppointmentModal.btnDeleteAppointmentClick(Sender: TObject);
begin
  dm.qAppointments.Delete;
  dm.qAppointments.Refresh;

  // Set record pop up message
  frmMain.Tag := 5;
  frmMain.RecordMessage('Appointment', 'appointment');

  rDeleteBackground.Visible := False;
  Self.Visible := False;

  // Form Visibility
  FormVisibility;
end;

{ Cancel Button - Delete }
procedure TfAppointmentModal.btnDeleteCancelClick(Sender: TObject);
begin
  rDeleteBackground.Visible := False;
end;

{ Close Button - Delete }
procedure TfAppointmentModal.btnDeleteCloseClick(Sender: TObject);
begin
  rDeleteBackground.Visible := False;
end;

{ Patient OnClosePopup }
procedure TfAppointmentModal.cbPatientClosePopup(Sender: TObject);
begin
  if cbPatient.Text = 'Select patient...' then
    cbPatient.FontColor := TAlphaColorRec.Gray
  else
    cbPatient.FontColor := TAlphaColorRec.Black;
end;

{ Patient OnEnter }
procedure TfAppointmentModal.cbPatientEnter(Sender: TObject);
begin
  if cbPatient.Text = 'Select patient...' then
    cbPatient.Text := '';

  cbPatient.Items.Clear;
  cbPatient.Items.Add('Select patient...');

  FAllPatients.Clear;

  dm.qPatientSelection.Close;
  dm.qPatientSelection.Open;

  while not dm.qPatientSelection.Eof do
  begin
    FAllPatients.Add(dm.qPatientSelection.FieldByName('fullname').AsString);
    cbPatient.Items.Add(dm.qPatientSelection.FieldByName('fullname').AsString);
    dm.qPatientSelection.Next;
  end;
end;

{ Patient OnExit }
procedure TfAppointmentModal.cbPatientExit(Sender: TObject);
begin
  if cbPatient.Text = '' then
    cbPatient.Text := 'Select patient...'
  else if cbPatient.Text = 'Select patient...' then
    cbPatient.FontColor := TAlphaColorRec.Gray
  else
    cbPatient.FontColor := TAlphaColorRec.Black;
end;

{ Patient OnTyping }
procedure TfAppointmentModal.cbPatientTyping(Sender: TObject);
var
  Filtered: TStringList;
  i: Integer;
  SearchText: string;
begin
  // Allow editing: Deselect any current item
  cbPatient.ItemIndex := -1;

  cbPatient.DropDown;

  SearchText := Trim(cbPatient.Text);

  Filtered := TStringList.Create;
  try
    for i := 0 to FAllPatients.Count - 1 do
    begin
      if (SearchText = '') or (Pos(LowerCase(SearchText), LowerCase(FAllPatients[i])) = 1) then
        Filtered.Add(FAllPatients[i]);
    end;

    cbPatient.Items.Clear;
    cbPatient.Items.Add('Select patient...');
    for i := 0 to Filtered.Count - 1 do
      cbPatient.Items.Add(Filtered[i]);
  finally
    Filtered.Free;
  end;
end;

{ OnChange Date }
procedure TfAppointmentModal.deDateChange(Sender: TObject);
begin
  // Show date text
  if Self.Visible then
  begin
    lPickDate.Text := FormatDateTime('mmm dd, yyyy', deDate.Date);
    deDate.TodayDefault := False;

    crDate.Visible := False;
  end;
end;

{ OnCheckChanged Date }
procedure TfAppointmentModal.deDateCheckChanged(Sender: TObject);
begin
  if deDate.Date = Now then
  begin
    // Set the date in label
    lPickDate.Text := FormatDateTime('mmm dd, yyyy', deDate.Date);
  end;
end;

{ OnClosePicker Date }
procedure TfAppointmentModal.deDateClosePicker(Sender: TObject);
begin
  lPickDate.Visible := True;
  lPickDate.FontColor := TAlphaColorRec.Black;
  deDate.StyledSettings := [TStyledSetting.Style];
  deDate.ResetFocus;
end;

{ OnEnter Date }
procedure TfAppointmentModal.deDateEnter(Sender: TObject);
begin
  lPickDate.Visible := False;
  deDate.CanFocus := True;
  deDate.StyledSettings := [TStyledSetting.Style, TStyledSetting.FontColor];
end;

{ OnExit Date }
procedure TfAppointmentModal.deDateExit(Sender: TObject);
begin
  lPickDate.Visible := True;
  deDate.StyledSettings := [TStyledSetting.Style];
end;

procedure TfAppointmentModal.deDateOpenPicker(Sender: TObject);
begin
  lPickDate.Visible := True;
  deDate.StyledSettings := [TStyledSetting.Style];
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
    rModalInfo.Margins.Left := 455;
    rModalInfo.Margins.Right := 455;
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
    mNotes.FontColor := TAlphaColorRec.Black;
  end;
end;

{ On Enter Notes }
procedure TfAppointmentModal.mNotesEnter(Sender: TObject);
begin
  if mNotes.Text = 'Add any relevant notes about this appointment' then
  begin
    MemoTrackingReset := 'Clicked';
    mNotes.Text := '';
    mNotes.FontColor := TAlphaColorRec.Black;
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
    mNotes.FontColor := TAlphaColorRec.Gray;
  end;
end;

procedure TfAppointmentModal.teStartTimeChange(Sender: TObject);
begin

end;

{ Close Button }
procedure TfAppointmentModal.btnCloseClick(Sender: TObject);
begin
  Self.Visible := False;

  // Close query
  dm.qPatientSelection.Close;

  FormVisibility;
end;

end.
