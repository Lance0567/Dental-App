unit uAppointmentModal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.Skia, FMX.Skia, FMX.ListBox, FMX.Effects, FMX.Objects, FMX.Edit,
  FMX.ImgList, FMX.Controls.Presentation, FMX.Layouts, FMX.DateTimeCtrls,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo;

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
    cbPatient: TComboBox;
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
    procedure btnCloseClick(Sender: TObject);
    procedure FrameResized(Sender: TObject);
    procedure lytDetails3Resized(Sender: TObject);
    procedure lytDetails4Resized(Sender: TObject);
    procedure deDateClosePicker(Sender: TObject);
    procedure mNotesClick(Sender: TObject);
    procedure mNotesExit(Sender: TObject);
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

uses uMain;

{ Clear items for add patient modal }
procedure TfAppointmentModal.ClearItems;
begin
  // Reset Date
  lPickDate.Visible := True;
  deDate.StyledSettings := deDate.StyledSettings - [TStyledSetting.FontColor];

  // Reset Status
  cbStatus.ItemIndex := 0;

  // Reset Patient
  cbPatient.ItemIndex := 0;

  // Reset Appointment Title
  eAppointmentTitle.Text := '';

  // Reset Notes
  MemoTrackingReset := 'Empty';
  mNotes.Text := 'Add any relevant notes about this appointment';
end;

{ On Close picker Date }
procedure TfAppointmentModal.deDateClosePicker(Sender: TObject);
begin
  // Hide Date pick label
  lPickDate.Visible := False;

  // Show date text
  deDate.StyledSettings := [TStyledSetting.Style];
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
  if (frmMain.ClientHeight >= 520) AND (frmMain.ClientWidth >= 870) then
  begin
    rModalInfo.Margins.Left := 455;
    rModalInfo.Margins.Right := 455;
    rModalInfo.Margins.Top := 60;
    rModalInfo.Margins.Bottom := 60;
  end;

  if (frmMain.ClientHeight <= 510) AND (frmMain.ClientWidth <= 860) then
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
  if MemoTrackingReset = 'Empty' then
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
end;

end.
