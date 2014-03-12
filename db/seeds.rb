ViolationRule.find_or_create_by({
  condition: 'user.time_entries.last >= 1.day.ago',
  assert_each: '1.day',
  description: 'User has no time entries at Toggl.com for the last day'
})
