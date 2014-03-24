ViolationRule.find_or_create_by({
  condition: 'agreement.worker_timings_by_project.last[:stop] >= 1.day.ago',
  assert_each: '1.day',
  description: 'User has no time entries at Toggl.com for the last day'
})
ViolationRule.find_or_create_by({
  condition: 'agreement.acceptable_pace?(3.day)',
  assert_each: '1.day',
  description: 'Worker worked less min timing at last 3 days'
})