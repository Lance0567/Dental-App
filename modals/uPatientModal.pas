unit uPatientModal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.ImgList, FMX.Controls.Presentation,
  FMX.Memo.Types, FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics,
  FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl, FMX.TMSFNCWebBrowser,
  FMX.TMSFNCCustomWEBControl, FMX.TMSFNCMemo, FMX.ScrollBox, FMX.Memo,
  FMX.DateTimeCtrls, FMX.Edit, FMX.ListBox;

type
  TfPatientModal = class(TFrame)
    rBackground: TRectangle;
    rModalInfo: TRectangle;
    lytContentH: TLayout;
    ScrollBox1: TScrollBox;
    lytButtonSaveH: TLayout;
    btnSavePatient: TCornerButton;
    lytMedicalNotes: TLayout;
    lbMedicalNotes: TLabel;
    mMedicalNotes: TMemo;
    lytPatientH: TLayout;
    lytPatientProfile: TLayout;
    cProfilePhoto: TCircle;
    gIcon: TGlyph;
    lNameH: TLabel;
    lbProfilePhoto: TLabel;
    btnPhotoUpload: TCornerButton;
    lytPatientDetails: TLayout;
    lytDetails1: TLayout;
    lytFullName: TLayout;
    lbFullName: TLabel;
    eFullName: TEdit;
    lytDateOfBirth: TLayout;
    lbDateOfBirth: TLabel;
    deDateOfBirth: TDateEdit;
    lAgeCounter: TLabel;
    lytDetails2: TLayout;
    lytGender: TLayout;
    lbGender: TLabel;
    cbGender: TComboBox;
    lytContactNumber: TLayout;
    lbContactNumber: TLabel;
    eContactNumber: TEdit;
    lytDetails3: TLayout;
    lytEmailAddress: TLayout;
    lbEmailAddress: TLabel;
    eEmailAddress: TEdit;
    lytAddress: TLayout;
    lbAddress: TLabel;
    eAddress: TEdit;
    lytTitle: TLayout;
    lbTitle: TLabel;
    btnClose: TSpeedButton;
    lTag: TLabel;
    lGenderText: TLabel;
    lDateText: TLabel;
    procedure mMedicalNotesClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure eFullNameChangeTracking(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure lytDetails1Resize(Sender: TObject);
    procedure lytDetails2Resize(Sender: TObject);
    procedure lytDetails3Resize(Sender: TObject);
    procedure cbGenderChange(Sender: TObject);
    procedure mMedicalNotesExit(Sender: TObject);
    procedure deDateOfBirthEnter(Sender: TObject);
  private
    { Private declarations }
  public
    MemoTrackingReset: String;
    procedure EditComponentsResponsive;
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uMain, uDm;

procedure TfPatientModal.cbGenderChange(Sender: TObject);
begin
  lGenderText.Text := cbGender.Text;
end;

procedure TfPatientModal.deDateOfBirthEnter(Sender: TObject);
begin
  deDateOfBirth.TextSettings.FontColor := TAlphaColors.Black;
  lDateText.Visible := False;
end;

procedure TfPatientModal.EditComponentsResponsive;
begin
  lytFullName.Width := Trunc(lytDetails1.Width / 2) - 15; // -15 to account for spacing
  lytDateOfBirth.Width := Trunc(lytDetails1.Width / 2) - 15;
  lytGender.Width := Trunc(lytDetails2.Width / 2) - 15;
  lytContactNumber.Width := Trunc(lytDetails2.Width / 2) - 15;
  lytEmailAddress.Width := Trunc(lytDetails3.Width / 2) - 15;
  lytAddress.Width := Trunc(lytDetails3.Width / 2) - 15;
end;

procedure TfPatientModal.btnCloseClick(Sender: TObject);
begin
  Self.Visible := False;
end;

procedure TfPatientModal.eFullNameChangeTracking(Sender: TObject);
begin
  // Getter of first letter of the Full name
  if eFullName.Text.Trim <> '' then
    lNameH.Text := UpperCase(eFullName.Text.Trim[1])
  else
  begin
    lNameH.Text := '';
    gIcon.ImageIndex := 10;
  end;

  // Profile pic changer
  gIcon.ImageIndex := -1;
  lNameH.Visible := True;
end;

procedure TfPatientModal.FrameResize(Sender: TObject);
begin
  // Modal content margins
  if (frmMain.ClientHeight >= 520) AND (frmMain.ClientWidth >= 870) then
  begin
  rModalInfo.Margins.Left := 310;
  rModalInfo.Margins.Right := 310;
  rModalInfo.Margins.Top := 60;
  rModalInfo.Margins.Bottom := 60;
  end;

  if (frmMain.ClientHeight <= 510) AND (frmMain.ClientWidth <= 860) then
  begin
    rModalInfo.Margins.Left := 70;
    rModalInfo.Margins.Right := 70;
    rModalInfo.Margins.Top := 30;
    rModalInfo.Margins.Bottom := 30;
  end;
end;

procedure TfPatientModal.lytDetails1Resize(Sender: TObject);
begin
  EditComponentsResponsive;
end;

procedure TfPatientModal.lytDetails2Resize(Sender: TObject);
begin
  EditComponentsResponsive;
end;

procedure TfPatientModal.lytDetails3Resize(Sender: TObject);
begin
  EditComponentsResponsive;
end;

procedure TfPatientModal.mMedicalNotesClick(Sender: TObject);
begin
  if MemoTrackingReset = 'Empty' then
  begin
    MemoTrackingReset := 'Clicked';
    mMedicalNotes.Text := '';
  end;

  lTag.Text := 'Tag Number : ' + MemoTrackingReset;
end;

procedure TfPatientModal.mMedicalNotesExit(Sender: TObject);
begin
  if (MemoTrackingReset = 'Clicked') AND (mMedicalNotes.Text.Trim.IsEmpty) then
  begin
    MemoTrackingReset := 'Empty';
  end;

  if (MemoTrackingReset = 'Empty') then
  begin
    mMedicalNotes.Text := 'Enter any relevant medical history, allergies, or notes';
  end;

  lTag.Text := 'Tag Number : ' + MemoTrackingReset;
end;

end.
