require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.section_name {Faker::Name.name}

Sham.user_name {Faker::Internet.user_name}
Sham.admin_user_name {|i| "machinist_admin#{i}"}
Sham.student_user_name {|i| "machinist_student#{i}"}
Sham.ta_user_name {|i| "machinist_ta#{i}"}
Sham.first_name {Faker::Name.first_name}
Sham.last_name {Faker::Name.last_name}
Sham.api_key {|i| "API_KEY_N_#{i}"}

Sham.filename { "#{Faker::Lorem.words(1)[0]}.java"}
Sham.group_name {|i| "machinist_group#{i}"}
Sham.grouping_name {|i| "machinist_grouping#{i}"}

Sham.short_identifier {|i| "machinist_A#{i}"}
Sham.description {Faker::Lorem.sentence(2)}
Sham.message {Faker::Lorem.sentence(2)}
Sham.due_date {rand(50).days.from_now}

Sham.notes_message {Faker::Lorem.paragraphs}

Sham.overall_comment {Faker::Lorem.sentence(3)}

Sham.flexible_criterion_name {|i| "machinist_flexible_criterion_#{i}"}
Sham.rubric_criterion_name {|i| "machinist_rubric_criterion_#{i}"}

Sham.date {rand(50).days.from_now}
Sham.name {Faker::Name.name}


Sham.filename {|i| "file#{i}"}
Sham.path {|i| "path#{i}"}

Sham.annotation_category_name {|i| "Machinist Annotation Category #{i}"}

Admin.blueprint do
  user_name {Sham.admin_user_name}
  first_name {Sham.first_name}
  last_name {Sham.last_name}
  api_key
end

AnnotationCategory.blueprint do
  assignment {Assignment.make}
  annotation_category_name {Sham.name}
end

AnnotationText.blueprint do
  annotation_category {AnnotationCategory.make}
  content {'content'}
end

Assignment.blueprint do
  short_identifier
  description
  message
  due_date
  group_min {2}
  group_max {4}
  student_form_groups {true}
  instructor_form_groups {false}
  repository_folder {"repo/#{short_identifier}"}
  marking_scheme_type {'rubric'}
  submission_rule {NoLateSubmissionRule.make}
  allow_web_submits {true}
  display_grader_names_to_students {false}
  section_due_dates_type(false)
  enable_test {true}
  tokens_per_day {10}
  assign_graders_to_criteria {false}
  assignment_stat {AssignmentStat.make}
end

AssignmentFile.blueprint do
  assignment
  filename
end

AssignmentStat.blueprint do
  assignment_id {0}
end

CriterionTaAssociation.blueprint do
  criterion
  ta
end

ExtraMark.blueprint do
  extra_mark {2}
  result
  unit{'percentage'}
end

FlexibleCriterion.blueprint do
  assignment {Assignment.make(:marking_scheme_type => 'flexible')}
  flexible_criterion_name
  description
  position {1} # override if many for the same assignment
  max{10}
  assigned_groups_count {0}
end

Grade.blueprint do
  grade_entry_item {GradeEntryItem.make}
  grade_entry_student {GradeEntryStudent.make}
  grade {0}
end

GracePeriodDeduction.blueprint do
  membership  {StudentMembership.make}
  deduction {20}
end

GracePeriodSubmissionRule.blueprint do
  assignment_id {0}
  type {'GracePeriodSubmissionRule'}
end

GradeEntryForm.blueprint do
  short_identifier
  description
  message
  date
end

GradeEntryItem.blueprint do
  grade_entry_form
  name
  out_of {10}
end

GradeEntryStudent.blueprint do
  grade_entry_form {GradeEntryForm.make}
  user {Student.make}
  released_to_student {false}
end

Group.blueprint do
  group_name {Sham.group_name}
  repo_name {group_name}
end

Grouping.blueprint do
  grouping_queue { nil }
  group {Group.make}
  assignment {Assignment.make}
  criteria_coverage_count {0}
end

ImageAnnotation.blueprint do
  x1 {0}
  x2 {10}
  y1 {0}
  y2 {10}
  submission_file
  annotation_text {AnnotationText.make(
    :annotation_category => AnnotationCategory.make(:assignment => submission_file.submission.grouping.assignment)
    )}
  annotation_text_id {1}
  submission_file_id {submission_file.id}
  annotation_number {rand(1000)+1}
end

Mark.blueprint do
  result {Submission.make.result}
  markable {RubricCriterion.make(:assignment => result.submission.grouping.assignment)}
  mark {1}
end

Mark.blueprint(:rubric) do
  result {Submission.make.result}
  markable {RubricCriterion.make(:assignment => result.submission.grouping.assignment)}
end

Mark.blueprint(:flexible) do
  result {Submission.make.result}
  markable {FlexibleCriterion.make(:assignment => result.submission.grouping.assignment)}
end

Note.blueprint do
  noteable_type  {'Grouping'}
  noteable_id {Grouping.make.id}
  user {Admin.make}
  notes_message  {Faker::Lorem.paragraphs}
end

NoLateSubmissionRule.blueprint do
  assignment_id {0}
end

Result.blueprint do
  submission {Submission.make}
  marking_state {Result::MARKING_STATES[:partial]}
  total_mark {0}
end

RubricCriterion.blueprint do
  assignment {Assignment.make(:marking_scheme_type => 'rubric')}
  rubric_criterion_name {Sham.rubric_criterion_name}
  position {1} # override if many for the same assignment
  weight {1}
  assigned_groups_count {0}
end

Section.blueprint do
  name {Sham.section_name}
end

SectionDueDate.blueprint do
  section {Section.make}
  assignment {Assignment.make}
  due_date
end

Student.blueprint do
  user_name {Sham.student_user_name}
  first_name {Sham.first_name}
  last_name {Sham.last_name}
  section
  grace_credits {5}
end

Student.blueprint(:hidden) do
  hidden { true }
end

StudentMembership.blueprint do
  user {Student.make}
  grouping
  membership_status {StudentMembership::STATUSES[:pending]}
end

Submission.blueprint do
  grouping {Grouping.make}
  submission_version {1}
  submission_version_used {true}
  revision_number {1}
  revision_timestamp {1.days.ago}
  remark_result_id {nil}
end

SubmissionFile.blueprint do
  submission
  filename {Sham.name}
  path {Sham.filename}
end

PenaltyDecayPeriodSubmissionRule.blueprint do
  assignment_id {0}
  type {'PenaltyDecayPeriodSubmissionRule'}
end

PenaltyPeriodSubmissionRule.blueprint do
  assignment_id {0}
  type {'PenaltyPeriodSubmissionRule'}
end

Period.blueprint do
  submission_rule_id {0}
  hours {rand(24)}
end

Ta.blueprint do
  user_name {Sham.ta_user_name}
  first_name {Sham.first_name}
  last_name {Sham.last_name}
  api_key
end

TaMembership.blueprint do
  user {Ta.make}
  grouping
  membership_status {'pending'}
end

TestFile.blueprint do
  assignment_id {0}
  filename
  filetype
  is_private {false}
end

TextAnnotation.blueprint do
  line_start {0}
  line_end {1}
  submission_file
  annotation_text {AnnotationText.make(
    :annotation_category => AnnotationCategory.make(:assignment => submission_file.submission.grouping.assignment)
    )}
  annotation_number {rand(1000)+1}
end

Token.blueprint do
  grouping_id {Grouping.make.id}
  tokens {5}
end
