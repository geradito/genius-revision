<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\GradeController;
use App\Http\Controllers\SubjectController;
use App\Http\Controllers\QuestionController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

// Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
//     return $request->user();
// });
 
Route::get('/categories', [CategoryController::class, 'index']);
Route::get('/categories/{id}/subjects', [CategoryController::class, 'showSubjects']); 
Route::get('/categories/{id}/grades', [CategoryController::class, 'showGrades']);  
Route::get('/grades/{id}/subjects', [GradeController::class, 'showSubjects']); 
Route::get('/subjects/{id}/questions', [SubjectController::class, 'showQuestions']);  
Route::post('/subjects', [SubjectController::class, 'store']);  
Route::post('/quizzes', [QuestionController::class, 'quiz']);  
