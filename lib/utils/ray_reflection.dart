import 'dart:math';
import 'package:vector_math/vector_math.dart';

// Define a ray starting at the origin and going into positive x-direction.
Ray ray = Ray.originDirection(Vector3.zero(), Vector3(1.0, 0.0, 0.0));
// Defines a sphere with the center (5.0 0.0 0.0) and a radius of 2.
Sphere sphere = Sphere.centerRadius(Vector3(5.0, 0.0, 0.0), 2.0);
// Checks if the ray intersect with the sphere and returns the distance of the
// intersection from the origin of the ray. Would return null if no intersection
// is found.
double? distanceFromOrigin = ray.intersectsWithSphere(sphere);
// Evaluate the position of the intersection, in this case (3.0 0.0 0.0).
Vector3 position = ray.at(distanceFromOrigin!);
Plane plane = Plane.components(0, 0, 0, 0);

//double? refg = ray.intersectsWithQuad(other)