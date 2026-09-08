# Delegation delivery

Read at kickoff and before collecting or sending completion. Parent collection is the default.
Use a callback only when the user requests it. Both modes use one authoritative artifact and one
receipt record. Repository-specific services, credentials, and acceptance gates belong to the
repository's contract, not the model route.

Record explicit workspace, sender session, recipient session, task, revision, assigned phase,
authority, artifact path, next owner, completion state, and delivery mode. Include background jobs
with their owner, handle, artifact, and state. Sender session env can be absent. Resolve identities
from kickoff and session metadata, never a guessed environment fallback.

Before launch, reserve the child session ID when supported, or record the returned ID and pass the
completed identity contract before work begins. Validate the callback recipient in the intended
workspace once using session metadata. No credential belongs in the prompt or artifact.

The child updates the artifact and explicitly marks phase completion. Every owned background job
must be completed, failed with a disclosed gap, or transferred with the next owner's acknowledgment.
An idle parent or child session is not proof that its background work ended.

For parent collection, the parent reads the artifact and fetches new transcript messages using its
last-message cursor. For an authorized callback, send only workspace/sender/recipient/task/revision
IDs, event ID, result, and artifact path. Use a stable task/revision/event key across both paths.
Record receipt before relaying the result. If a send times out, inspect the recipient transcript or
receipt before retrying. Do not send a duplicate because the same completion also appears in a poll.
Artifacts remain authoritative when a notification is missing or arrives out of order.

The parent verifies the artifact's revision, scope, and evidence before reporting it. One watcher
reports state transitions, findings, failures, and completion rather than repeating full reports.
Higher-priority runtime commentary requirements still apply.
