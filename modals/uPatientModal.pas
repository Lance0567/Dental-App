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
    lytPatientH: TLayout;
    lytMedicalNotes: TLayout;
    lytButtonSaveH: TLayout;
    btnSavePatient: TCornerButton;
    lytContentH: TLayout;
    lytPatientProfile: TLayout;
    lytPatientDetails: TLayout;
    lytTitle: TLayout;
    lbTitle: TLabel;
    lbMedicalNotes: TLabel;
    cProfilePhoto: TCircle;
    lbProfilePhoto: TLabel;
    gIcon: TGlyph;
    mMedicalNotes: TMemo;
    lytDetails1: TLayout;
    lytFullName: TLayout;
    lbFullName: TLabel;
    eFullName: TEdit;
    lytDateOfBirth: TLayout;
    lbDateOfBirth: TLabel;
    deDateOfBirth: TDateEdit;
    lAgeCounter: TLabel;
    btnPhotoUpload: TCornerButton;
    lytDetails2: TLayout;
    lytGender: TLayout;
    lbGender: TLabel;
    cbGender: TComboBox;
    lytContactNumber: TLayout;
    lbContactNumber: TLabel;
    eContactNumber: TEdit;
    btnClose: TSpeedButton;
    ScrollBox1: TScrollBox;
    lytDetails3: TLayout;
    lytEmailAddress: TLayout;
    lbEmailAddress: TLabel;
    lytAddress: TLayout;
    lbAddress: TLabel;
    eAddress: TEdit;
    eEmailAddress: TEdit;
    lNameH: TLabel;
    procedure mMedicalNotesClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure eFullNameChangeTracking(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uDm;

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
    lNameH.Text := '';

  // Profile pic changer
  gIcon.Visible := False;
  lNameH.Visible := True;
end;

procedure TfPatientModal.mMedicalNotesClick(Sender: TObject);
begin
  mMedicalNotes.Text := '';
end;

end.
