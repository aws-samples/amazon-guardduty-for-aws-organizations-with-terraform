# Runbook for Disabling Amazon GuardDuty

## Use Case

If an organization already has enabled GuardDuty in a manual way, using the `Member-Invite` method, this run-book prescribes the process to "undo" that method as a prerequisite to the automated solution using AWS Organizations and the included Terraform code.

## Benefits of Deploying Amazon GuardDuty with AWS Organizations

When integrated with AWS Organizations, any new account added to an AWS Organization is also automatically discovered and enabled by the GuardDuty Delegated Administrator without the need to turn on GuardDuty for each member account. Based on the [Design principles for your multi-account strategy](https://docs.aws.amazon.com/whitepapers/latest/organizing-your-aws-environment/design-principles-for-your-multi-account-strategy.html) or default [AWS Control Tower](https://docs.aws.amazon.com/controltower/latest/userguide/accounts.html) configuration, it is recommended to set up the `Security Tooling` or `Audit` account as the Delegated Administrator for GuardDuty, to maintain separation of duties.

## Turn off Member-Invite Deployment

- Login to the GuardDuty Delegated Administrator account with appropriate GuardDuty permissions via the `AWS Management Console`

![Amazon GuardDuty Management Console, Accounts table](images/runbook_step2.png)

- Navigate to the `GuardDuty Management Console`, and click on `Settings`, then `Accounts` in the left panel

![Amazon GuardDuty Management Console, Disable S3 Protection](images/runbook_step3.png)

- Select the relevant Member Accounts that have S3 protection enabled and click on `Disable S3 protection`
- Select all the Member Accounts and click on `Suspend GuardDuty` under `Actions`
- Select all the Member Accounts and click on `Disassociate account` under `Actions`

![Amazon GuardDuty Management Console, Findings table](images/runbook_step7.png)

- Click on `Findings` in the left panel and change the view pane to display `ALL findings` instead of `Current findings only`
- (Optional) Select `All findings` and under `Actions`, click on `Export`. Click on `Download` to download findings in JSON format
- Disable GuardDuty in all the Member accounts. Login to each member account and select `GuardDuty`. Go to `Settings`, `Disable GuardDuty` for each region where GuardDuty was enabled
- Disable GuardDuty in the Delegated Administrator account. Login to the Delegated Administrator account and navigate to the `GuardDuty Management Console`. Click on `Settings` in the left panel, then click on `Disable GuardDuty` for each reagion where GuardDuty was enabled. Once disabled, all your existing findings and the GuardDuty configuration are lost and cannot be recovered

![Disable GuardDuty Confirmation](images/runbook_step10.png)

Note: GuardDuty is a regional service. Before proceeding, ensure that the above actions are completed in all regions in which GuardDuty was previously enabled
