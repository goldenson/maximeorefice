---
layout: post
title: "📚 Code Review"
# date: 2020-03-22
---

Some tips and suggestions on how to do code reviews...

## Getting context

First step is making sure you understand the **purpose** of the change. Some questions to ask yourself:

- Is it fixing a bug?
- Are there reproducible steps for the bug?
- Is it adding a feature?
- Is it a refactoring that should not change functionality? What is the refactoring trying to achieve?
- Is it part of a sequence of changes that build on each other towards some other goal? Is that overall goal stated or linked to the PR?

If you can’t answer these questions, then it is a problem with the PR. The author didn’t give enough explanation or justification. It is perfectly valid to stop at this point and ask questions in the PR about what is unclear to you. You may think there is a purpose you don’t understand and you don’t want to look clueless by asking, but chances are other people with even less context than you will look back at this PR in the future and be equally confused. The purpose of the change must be clear. Sometimes by asking questions you’ll help the author realize they didn’t fully understand the purpose either and it helps them discover other approaches to the problem.

## Deciding how deep to review

Reviewing can be a rabbit hole that takes up a huge amount of time if you go into every review to extreme detail. Sometimes a very deep review is needed, and other times a quick inspection is enough. Some of the factors to help you decide how deep you need to go:

- Is there a large effect of this change on the design and architecture of the code base? Is it setting a precedent in the code base or incrementally adding functionality in a consistent style with what’s there already?
- Is this touching code paths already in production, or is it work in progress or internal code, or behind feature flag?
- What could go wrong if this change is bad? Is there a large potential runtime impact? Is it code touching critical feature paths such as financial transactions, orders, and signups, or critical infrastructure code paths such as routing and authentication?
- Is there a high educational or knowledge transfer value in the review? Is this an area you know little about where there is a chance to learn from an expert author? Or is this a code base you know deeply and there is an opportunity to transfer context to the author?

If there is little value in terms of reducing risk, maintaining overall code quality, or knowledge transfer then it is probably not worth a very deep dive. And again, if you can’t answer these questions from looking at the PR, **ask questions** in the PR.

If these factors point to the need for a very deep review, it is fair to ask yourself whether you are the right person to approve the change. Do the review anyway, but it is perfectly fair to say at the end, “I did a review but this is a high risk change and I have little expertise in this area, so we should get an extra review from so-and-so”. There is an important difference between “I didn’t find any problems”, and “I believe this change is ready for production”. You should be clear if your review only got as far as “no problems”, but aren’t comfortable declaring, “It’s ready”. Nobody will fault you for saying that. Approving a change makes you equally responsible with the PR author for what happens when the code is released.

## Levels of review

There are lots of different ways to approach a review. It takes some experience to decide which ones to use for any given change, based on the risk/value mentioned earlier. Here are some approaches, and typically you will need one or more but not all of these:

- Reviewing the end goal of the change, and checking whether it met that goal (most important)
- Reviewing the code architecture. How are the different modules and concerns abstracted, and do they make sense and are consistent with the existing code
- Reviewing the end user perspective. What effect does the change have on the end user? Will the change be intuitive and discoverable for a typical end user of the application? Do we need to document, train, or do some kind of outreach to avoid surprises.
- Reviewing the tests. Is the change well tested, do the tests have appropriate assertions for both correct usage flows and abnormal cases? Do they make appropriate use of fixtures?
- Algorithmic review. What is the complexity of the algorithms introduced or changed? Are the most efficient library method calls being used for the task at hand.
- Infrastructure review. Is there an impact on storage requirements, network requirements, container impact, etc
- Reviewing syntax and style (least important, but still worthwhile). Avoid subjective stuff unless there is a clear style guide that is consistently followed

## Reviewing bug fixes

Bug fixes are probably the easiest changes to review. The key things to look for:

- Is there a reproducible test case for the bug? Ideally this is one or more unit tests supplied with the PR. If you apply only the test changes from the PR, one or more of the new tests should fail. You would be surprised how many times this isn’t true - bugs in the tests such as lack of proper assertions is common! Some bugs are very hard to reproduce with the test case, but the vast majority should have an automated test. If there is no automated test is there at least a way to reproduce the bug via the end user interface?
- Is the fix in the right place? Sometimes a fix only addresses a superficial side-effect or symptom of the bug and not the root cause. For example catching exceptions rather than validating the incoming data at the right place.
- Is there a pattern where the same kind of failure can occur in other parts of the code base (other views, models, etc). Sometimes a fix only addresses a single instance of the problem but if you look around you can find the same bad code pattern duplicated elsewhere that also needs fixing.

## Reviewing database changes

Some things to look for when reviewing data (schema) changes:

- Is the new data in the right place? Why is it in that table and not another one?
- Is the data structure for efficient lookup? How will the data be retrieved? Does it index the right keys, and does it contain the properties that will be needed for filtering and sorting?
- Are we capturing too much data? Estimate the growth of the data set over time and think whether it is sustainable. Can we be aggregating existing data rather than adding new rows?

## Reviewing view changes

There is no good substitute for old fashioned manual testing when dealing with view changes (“top-hatting”). Run with the changes and ask yourself:

- Does it render and layout ok? Is it consistent with the existing appearance of the app?
- If I shrink my display port to mobile/tablet dimensions does it adapt reasonably?
- Is the new/changed functionality discoverable without being told where to look?
- Try clicking on everything that can be clicked to validate what happens
- If there is something accepting input, try some unusual or large values and see how it behaves.
- Are there unit tests that load this page? At least basic route or controller tests should be possible.

## Reviewing performance fixes

Sometimes a chance is being made to improve performance. Some things to look out for:

- What was the performance before? How was it measured? Was the performance actually a problem?
- How big is the performance gain, and is it reproducible?
- Often performance is a trade-off between speed and space. Eg, adding caching to make something faster. If the change improves speed, what was the space trade-off? Vice-versa if it was a memory/disk/space improvement. Is the trade-off worthwhile?
- What is the algorithmic complexity of the code before/after the change. How will it behave if the input is 10x or 100x larger? For almost everything at Shopify you should be ready to handle a 3-4x growth without further changes.

## Deeper review questions

Here are some questions to consider when doing a very deep code review (via Simon E):

- If I remove a given line of code, does a test fail?
- Are any of the tests flaky? Run it in a loop.
- Is any complexity added from trying to anticipate future use-cases of the code?
- For every external call, what happens if it fails?
- Are any abstractions leaked into other code?
- Does this code (test or implementation) address a symptom rather than a root cause?
- Are the tests tightly coupled making refactoring harder in the future?
- Can I explain with one sentence what each module does?
- Can this be broken up into multiple pieces?
- Is the code tightly coupled? Is the law of demeter honoured?
- Can a developer do something wrong? If it doesn't work, does the error tell them easily what to do?
- If one of the assumptions (implicit / explicit) in here are blown away by someone changing the code, will a test fail?
- Does this build for the platform, or for one very specific problem?
- Does this have any implications on the development environment?

---

# **Code Review from thoughtbout**

A guide for reviewing code and having your code reviewed.

## **Everyone**

- Accept that many programming decisions are opinions. Discuss tradeoffs, which you prefer, and reach a resolution quickly.
- Ask good questions; don't make demands. ("What do you think about naming this `:user_id`?")
- Good questions avoid judgment and avoid assumptions about the author's perspective.
- Ask for clarification. ("I didn't understand. Can you clarify?")
- Avoid selective ownership of code. ("mine", "not mine", "yours")
- Avoid using terms that could be seen as referring to personal traits. ("dumb", "stupid"). Assume everyone is intelligent and well-meaning.
- Be explicit. Remember people don't always understand your intentions online.
- Be humble. ("I'm not sure - let's look it up.")
- Don't use hyperbole. ("always", "never", "endlessly", "nothing")
- Don't use sarcasm.
- Keep it real. If emoji, animated gifs, or humor aren't you, don't force them. If they are, use them with aplomb.
- Talk synchronously (e.g. chat, screensharing, in person) if there are too many "I didn't understand" or "Alternative solution:" comments. Post a follow-up comment summarizing the discussion.

## **Having Your Code Reviewed**

- Be grateful for the reviewer's suggestions. ("Good call. I'll make that change.")
- A common axiom is "Don't take it personally. The review is of the code, not you." We used to include this, but now prefer to say what we mean: Be aware of [how hard it is to convey emotion online](https://www.fastcodesign.com/3036748/why-its-so-hard-to-detect-emotion-in-emails-and-texts) and how easy it is to misinterpret feedback. If a review seems aggressive or angry or otherwise personal, consider if it is intended to be read that way and ask the person for clarification of intent, in person if possible.
- Keeping the previous point in mind: assume the best intention from the reviewer's comments.
- Explain why the code exists. ("It's like that because of these reasons. Would it be more clear if I rename this class/file/method/variable?")
- Extract some changes and refactorings into future tickets/stories.
- Link to the code review from the ticket/story. ("Ready for review: [https://github.com/organization/project/pull/1](https://github.com/organization/project/pull/1)")
- Push commits based on earlier rounds of feedback as isolated commits to the branch. Do not squash until the branch is ready to merge. Reviewers should be able to read individual updates based on their earlier feedback.
- Seek to understand the reviewer's perspective.
- Try to respond to every comment.
- Wait to merge the branch until Continuous Integration (TDDium, TravisCI, etc.) tells you the test suite is green in the branch.
- Merge once you feel confident in the code and its impact on the project.

## **Reviewing Code**

Understand why the change is necessary (fixes a bug, improves the user experience, refactors the existing code). Then:

- Communicate which ideas you feel strongly about and those you don't.
- Identify ways to simplify the code while still solving the problem.
- If discussions turn too philosophical or academic, move the discussion offline to a regular Friday afternoon technique discussion. In the meantime, let the author make the final decision on alternative implementations.
- Offer alternative implementations, but assume the author already considered them. ("What do you think about using a custom validator here?")
- Seek to understand the author's perspective.
- Sign off on the pull request with a  or "Ready to merge" comment.

    👍

## **Style Comments**

Reviewers should comment on missed [style](https://github.com/thoughtbot/guides/blob/master/style) guidelines. Example comment:

    [Style](../style):

    > Order resourceful routes alphabetically by name.

An example response to style comments:

    Whoops. Good catch, thanks. Fixed in a4994ec.

If you disagree with a guideline, open an issue on the guides repo rather than debating it within the code review. In the meantime, apply the guideline.

This PR is way too long and needs some extra attention. Most developers as soon as they bump into a PR this big will most likely do a very bad job reviewing it and will ignore it until they have a large chunk of time to review. As you can tell this will prevent you from shipping the code fast enough, delaying the whole project. Also, there are many potential threats in shipping a PR this big - even though it's a WIP project. The foundation of any craft is normally the most important part of the whole thing since if something starts incorrectly, going back to fix it is likely to be more complex.

My suggestion has always been to work in smaller chunks to speed up the implementation and review process. For the Fraud Protect Sell Page I would consider these steps:

- Add a route in Web that is only accessible if Internal Routes are enabled, this will prevent the WIP code to be displayed in production.
- Add section by section in isolation, keep the scope short and targeted, break up even each section into smaller chunks if necessary.
- Connect with the API.
- Once all the sections are in place, QA it with the team and remove the Internal Routes limitation - Now your project is live in production.

Now, just a question. How have you been QAing this locally? You didn’t add the routes yet right.


## Links

- [Nelify Code Review](https://www.netlify.com/blog/2020/03/05/feedback-ladders-how-we-encode-code-reviews-at-netlify/)
