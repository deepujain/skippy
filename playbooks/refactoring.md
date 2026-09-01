# Refactoring Playbook

1. Define the caller-visible behavior, compatibility guarantees, and ownership
   boundaries that must remain unchanged.
2. Capture characterization evidence before moving code. Prefer observable
   behavior at public or integration boundaries over source-shape assertions.
3. Remove duplicate ownership or obsolete paths before adding a new abstraction.
4. Apply the structural change in small reversible units and keep the diff easy
   to review.
5. Re-run characterization evidence and the relevant integration checks after
   the final shape is in place.
6. State intentionally deferred cleanup and any unverified environmental path
   in the delivery receipt.
