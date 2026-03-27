# Section 6: EKS Pod Identity Agent

<details open>
<summary><b>Section 6: EKS Pod Identity Agent (G3PCS46)</b></summary>

## Table of Contents

- [6.1 Introduction to EKS Pod Identity Agent](#61-introduction-to-eks-pod-identity-agent)
- [6.2 PIA Demo Part-1](#62-pia-demo-part-1)
- [6.3 PIA Demo Part-2](#63-pia-demo-part-2)
- [Summary](#summary)

## 6.1 Introduction to EKS Pod Identity Agent

### Overview

This section introduces the concept of EKS Pod Identity Agent, a mechanism that allows pods running in an Amazon Elastic Kubernetes Service (EKS) cluster to securely access AWS services without managing long-lived credentials. We'll explore how applications deployed as pods can interact with services like Amazon S3, DynamoDB, and SQS, and the step-by-step process to implement this functionality using IAM roles and service accounts.

### Key Concepts/Deep Dive

#### Understanding EKS Pod Identity Agent
- **Core Problem**: Pods in an EKS cluster need to access AWS services (e.g., S3 buckets for storage, DynamoDB for NoSQL database, SQS for queuing/messaging systems) based on application requirements.
- **Solution**: EKS Pod Identity Agent enables secure access through temporary credentials obtained via IAM roles associated with service accounts.
- **Architecture**:
  ```mermaid
  flowchart LR
      A[Pod] --> B[EKS Pod Identity Agent]
      B --> C[IAM Role]
      C --> D[AWS Services]
  ```

#### Implementation Steps
1. **Create IAM Role**: Define an IAM role with specific permissions (e.g., S3 read-only access).
2. **Install EKS Pod Identity Agent**: Deploy as a DaemonSet on each EKS worker node to handle authentication.
3. **Create Service Account**: Kubernetes service account for the pod to use.
4. **Establish Pod Identity Association**: Link the IAM role, service account, and namespace.

#### Demo Setup
- **Test Application**: AWS CLI pod deployed in EKS to test S3 bucket access.
- **Expected Behavior**:
  - Initial attempt fails due to lack of permissions.
  - After setup, successful S3 bucket listing.

#### Related AWS Services Access Examples
- **S3**: Storage integration.
- **DynamoDB**: NoSQL database access.
- **SQS**: Message queuing.
- **EBS**: Block storage (covered in upcoming section).

> [!NOTE]
> This concept extends to any AWS service requiring IAM-based authentication from EKS pods.

### Lab Demos

**Basic Setup for Testing**:
- Deploy an EKS cluster.
- Prepare AWS CLI pod manifest with service account.

Instructions will be expanded in subsequent demo sections.

## 6.2 PIA Demo Part-1

### Overview

Part-1 of the demo focuses on setting up the EKS Pod Identity Agent addon and deploying a basic AWS CLI pod without authentication configured. We verify the initial failure when attempting to access S3 resources, establishing the baseline before implementing full Pod Identity.

### Key Concepts/Deep Dive

#### Installing EKS Pod Identity Agent Addon
- **Add-on Location**: In EKS Console > Add-ons > Get More Add-ons.
- **Component**: Amazon EKS Pod Identity Agent.
- **Deployment Type**: DaemonSet ensuring one pod per worker node.
- **Verification Commands**:
  ```bash
  kubectl get ds -n kube-system
  kubectl get pods -n kube-system -o wide
  kubectl get nodes -o wide
  ```

#### Creating Service Account and Pod Manifest
- **Service Account**: `aws-cli-sa` in `default` namespace.
- **Pod Configuration**:
  ```yaml
  apiVersion: v1
  kind: Pod
  metadata:
    name: aws-cli
    namespace: default
  spec:
    serviceAccountName: aws-cli-sa
    containers:
    - name: aws-cli
      image: amazon/aws-cli
      command: ["sleep", "infinity"]
  ```
- **Deployment**: `kubectl apply -f kube-manifest/`

#### Testing Initial Access (Expected Failure)
- **Command**: `kubectl exec -it aws-cli -- aws s3 ls`
- **Result**: Access denied error.
  - Reason: Pod uses node's instance IAM role, which lacks S3 permissions.

> [!IMPORTANT]
> This failure confirms the need for dedicated Pod Identity setup.

#### Components Overview
| Component | Description |
|-----------|-------------|
| EKS Pod Identity Agent | Authenticates pods with AWS services |
| Service Account | Kubernetes entity for pod identity |
| AWS CLI Pod | Test pod for S3 access |

### Lab Demos

**Demo: Install Pod Identity Agent**
1. Navigate to EKS Console > Clusters > EKS Demo1 > Add-ons.
2. Click "Get More Add-ons" and select "Amazon EKS Pod Identity Agent".
3. Click "Next" through defaults and "Create".
4. Wait for status to become "Active".
5. Verify with `kubectl get ds -n kube-system | grep pod-identity`.

**Demo: Deploy AWS CLI Pod**
1. Create Service Account:
   ```bash
   kubectl apply -f kube-manifest/service-account.yaml
   ```
2. Create Pod:
   ```bash
   kubectl apply -f kube-manifest/pod.yaml
   ```
3. Verify resources:
   ```bash
   kubectl get sa -n default
   kubectl get pods
   ```
4. Test access (expect failure):
   ```bash
   kubectl exec -it aws-cli -- aws s3 ls
   ```

## 6.3 PIA Demo Part-2

### Overview

Part-2 completes the Pod Identity implementation by creating the necessary IAM role, establishing the pod identity association, and testing successful access. We then clean up all resources, demonstrating the full lifecycle of the setup.

### Key Concepts/Deep Dive

#### Creating IAM Role
- **Role Type**: AWS service role for EKS - Pod Identity.
- **Permissions**: Attach `AmazonS3ReadOnlyAccess` policy.
- **Role Name**: `eks-pod-identity-s3-read-only-role-101`
- **Trust Policy**: Auto-configured for Pod Identity.

#### Establishing Pod Identity Association
- **Location**: EKS Console > Clusters > EKS Demo1 > Access > Pod Identity Associations.
- **Parameters**:
  - IAM Role: `eks-pod-identity-s3-read-only-role-101`
  - Namespace: `default`
  - Service Account: `aws-cli-sa`
- **Effect**: Links IAM role with Kubernetes service account.

#### Testing Successful Access
- **Pod Restart**: Delete and recreate pod to apply changes.
  ```bash
  kubectl delete pod aws-cli
  kubectl apply -f kube-manifest/pod.yaml
  ```
- **Verification**: `kubectl get pods`
- **Access Test**: `kubectl exec -it aws-cli -- aws s3 ls`
  - Result: Lists S3 buckets successfully.

#### Cleanup Process
1. Delete service account and pod manifests.
2. Remove Pod Identity Association from EKS Console.
3. Delete IAM role from IAM Console.

> [!WARNING]
> Ensure pods are no longer using the identity before deletion to avoid service disruptions.

### Lab Demos

**Demo: Create IAM Role**
1. Go to IAM Console > Roles > Create role.
2. Select "AWS service" > "EKS - Pod Identity".
3. Attach `AmazonS3ReadOnlyAccess` policy.
4. Name: `eks-pod-identity-s3-read-only-role-101`.
5. Create role.

**Demo: Create Pod Identity Association**
1. In EKS Console, navigate to cluster > Access > Pod Identity Associations.
2. Click "Create".
3. Select the IAM role, namespace `default`, service account `aws-cli-sa`.
4. Create association.

**Demo: Test Authenticated Access**
1. Delete existing pod:
   ```bash
   kubectl delete pod aws-cli
   ```
2. Recreate pod:
   ```bash
   kubectl apply -f kube-manifest/
   kubectl get pods
   ```
3. Test S3 access:
   ```bash
   kubectl exec -it aws-cli -- aws s3 ls
   ```
   - Expected: List of S3 buckets displayed.

**Demo: Cleanup**
1. Delete manifests:
   ```bash
   kubectl delete -f kube-manifest/
   ```
2. Remove Pod Identity Association from EKS Console.
3. Delete IAM role from IAM Console.

> [!NOTE]
> Transcript corrections: Changed "exports" to "EKS", "ECS cluster" to "EKS cluster", "Old p I a" to "EKS Pod Identity", "Im role" to "IAM role", "cubectl" to "kubectl", "Zero four" to "04", "04" contexts to "04", "hyphenn" to "hyphen n", and "hyphen" to "-".

## Summary

### Key Takeaways
```diff
+ Secure Access: EKS Pod Identity Agent enables pods to access AWS services using IAM roles without embedded credentials.
+ Step-by-Step Setup: Involves IAM role creation, agent installation, service account setup, and association configuration.
+ Authentication Flow: Pods use temporary credentials via the identity agent running as a DaemonSet.
- Initial Failure Expected: Without setup, pods use node instance role which lacks permissions.
! DaemonSet Deployment: Pod Identity Agent runs on every worker node for consistent authentication.
+ Cleanup Essential: Remove associations, roles, and resources promptly after demos.
```

### Quick Reference

#### Key Commands
- Install addon: Select in EKS Console Add-ons.
- Deploy resources: `kubectl apply -f kube-manifest/`
- Test S3 access: `kubectl exec -it aws-cli -- aws s3 ls`
- Verify DaemonSet: `kubectl get ds -n kube-system`

#### IAM Policy Example
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "*"
    }
  ]
}
```

### Expert Insight

**Real-world Application**: In production environments, use Pod Identity for applications like data pipelines accessing S3, microservices querying DynamoDB, or event-driven systems using SQS. It eliminates credential management overhead and enhances security by using AWS STS for temporary credentials.

**Expert Path**: Master granular permissions by combining this with Kubernetes RBAC. Study AWS STS integration, monitor credential usage through CloudTrail, and implement least-privilege IAM policies. Explore advanced scenarios like cross-account access and integration with AWS Config for compliance.

**Common Pitfalls**: Forgetting to restart pods after association creation, mismatching namespaces/service accounts, or neglecting cleanup leading to orphaned resources. Also, avoid using instance roles with broad permissions as a workaround—always implement proper Pod Identity for scalability and security.

</details>
